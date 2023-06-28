unit App.DataManager;

interface

uses
  System.Types, System.SysUtils, Vcl.ComCtrls, System.Win.WinRT, UWP.OcrEngine, Math.Vectors, Math, Winapi.Windows,
  Winapi.Winrt;

const
  SLINE_TEXT_FMT = '%s %d: %s';
  SLINE_TEXT = 'Line';

  SWORD_TEXT_FMT = '%s %d: %s';
  SWORD_TEXT = 'Word';

type
  POcrWord = ^TOcrWord;

  TOcrWord = record
  public
    Text: string;
    Rect: TRectF;
    Node: TTreeNode;
    property Left: Single read Rect.Left;
    property Top: Single read Rect.Top;
    property Right: Single read Rect.Right;
    property Bottom: Single read Rect.Bottom;
  end;

  POcrLine = ^TOcrLine;

  TOcrLine = record
  private
    function GetWordFromIndex(Index: Integer): POcrWord;
    function GetWordsCount: Integer;
  public
    Text: string;
    Words: array of TOcrWord;

    property Word[Index: Integer]: POcrWord read GetWordFromIndex; default;
    property WordsCount: Integer read GetWordsCount;
  end;

  PWordLocation = ^TWordLocation;

  TWordLocation = record
    LineIdx: Integer;
    WordIdx: Integer;
  end;

  TTreeViewDataManager = class
  private
    FLines: TArray<TOcrLine>;
    FTreeView: TTreeView;

    procedure ClearTreeViewData;
    procedure LoadWords(OcrLineIntf: IOcrLine; var ALine: TOcrLine);
    function SetLocation(LineIndex, WordIndex: Integer; OwnerNode: TTreeNode): PWordLocation;
    function GetOrcLinePtr(Index: Integer): POcrLine;
    function GetLinesCount: Integer;
  public
    constructor Create(TV: TTreeView);
    destructor Destroy; override;

    procedure ClearTreeView;
    procedure DisplayData;
    procedure InitWithResult(OcrResultIntf: IOcrResult);
    function FindWordNodeAt(const APoint: TPointF): TTreeNode;
    function GetNodeData(ANode: TTreeNode): PWordLocation;
    function GetWord(ALine, AWord: Integer): POcrWord;

    property Line[Index: Integer]: POcrLine read GetOrcLinePtr;
    property LinesCount: Integer read GetLinesCount;
    property TreeView: TTreeView read FTreeView;
  end;

implementation

{ TLine }

function TOcrLine.GetWordFromIndex(Index: Integer): POcrWord;
begin
  Result := @Self.Words[Index];
end;

{ TTreeViewDataManager }

procedure TTreeViewDataManager.ClearTreeView;
begin
  ClearTreeViewData;

  FTreeView.Items.Clear;
end;

procedure TTreeViewDataManager.ClearTreeViewData;
begin
  for var i := 0 to FTreeView.Items.Count - 1 do
    if FTreeView.Items[i].Data <> nil then
    begin
      FreeMem(FTreeView.Items[i].Data);
      FTreeView.Items[i].Data := nil;
    end;
end;

constructor TTreeViewDataManager.Create(TV: TTreeView);
begin
  FTreeView := TV;
end;

destructor TTreeViewDataManager.Destroy;
begin
  ClearTreeViewData;
  Finalize(FLines);
  FTreeView := nil;

  inherited;
end;

procedure TTreeViewDataManager.DisplayData;
var
  tvi: TTreeNodes;
  nodeLine, nodeWord: TTreeNode;
  line: POcrLine;
  word: POcrWord;
begin
  ClearTreeView;

  tvi := FTreeView.Items;
  tvi.BeginUpdate;

  try
    for var li := 0 to High(FLines) do
    begin
      line := @FLines[li];

      nodeLine := tvi.Add(nil, Format(SLINE_TEXT_FMT, [SLINE_TEXT, li + 1, line^.Text]));

      for var wi := 0 to High(line^.Words) do
      begin
        word := @line^.Words[wi];

        nodeWord := tvi.AddChild(nodeLine, Format(SWORD_TEXT_FMT, [SWORD_TEXT, wi + 1, word^.Text]));

        nodeWord.Data := SetLocation(li, wi, nodeWord);

        tvi.AddChild(nodeWord, Format('(x=%f, y=%f) (x=%f, y=%f)', [word^.Left, word^.Top, word^.Right, word^.Bottom]));
      end;
    end;
  finally
    tvi.EndUpdate;
  end;

end;

function TTreeViewDataManager.FindWordNodeAt(const APoint: TPointF): TTreeNode;
begin
  Result := nil;

  for var li in FLines do
    for var wi in li.Words do
      // Alternative for "contains" method with correct right+bottom comparison
      if (APoint.X >= wi.Rect.Left)
        and (APoint.X < wi.Rect.Left + wi.Rect.Right)
        and (APoint.Y >= wi.Rect.Top)
        and (APoint.Y < wi.Rect.Top + wi.Rect.Bottom) then
        Exit(wi.Node);
end;

function TTreeViewDataManager.GetLinesCount: Integer;
begin
  Result := Length(FLines);
end;

function TTreeViewDataManager.GetOrcLinePtr(Index: Integer): POcrLine;
begin
  Result := @FLines[Index];
end;

function TTreeViewDataManager.GetWord(ALine, AWord: Integer): POcrWord;
begin
  Result := @FLines[ALine].Words[AWord];
end;

function TTreeViewDataManager.GetNodeData(ANode: TTreeNode): PWordLocation;
begin
  Result := nil; // avoid warning W1035

  if (ANode <> nil) then
    Result := ANode.Data;
end;

procedure TTreeViewDataManager.InitWithResult(OcrResultIntf: IOcrResult);
var
  linesColl: IVectorView_1__Ocr_IOcrLine;
  oOcrLine: IOcrLine;
  linesCount: Integer;
begin
  ClearTreeView;
  Finalize(FLines);

  linesColl := OcrResultIntf.get_Lines;
  linesCount := linesColl.Size;

  SetLength(FLines, linesCount);

  for var li := 0 to linesCount - 1 do
  begin
    oOcrLine := linesColl.GetAt(li);

    FLines[li].Text := oOcrLine.get_Text.ToString;
    LoadWords(oOcrLine, FLines[li]);
  end;
end;

procedure TTreeViewDataManager.LoadWords(OcrLineIntf: IOcrLine; var ALine: TOcrLine);
var
  wordsColl: IVectorView_1__Ocr_IOcrWord;
  oOcrWord: IOcrWord;
  wordsCount: Integer;
  wr: TRectF;
begin
  wordsColl := OcrLineIntf.get_Words;
  wordsCount := wordsColl.Size;

  SetLength(ALine.Words, wordsCount);

  for var wi := 0 to wordsCount - 1 do
  begin
    oOcrWord := wordsColl.GetAt(wi);

    wr := oOcrWord.get_BoundingRect;

    ALine.Words[wi].Text := oOcrWord.get_Text.ToString;
    ALine.Words[wi].Rect := wr;
  end;
end;

function TTreeViewDataManager.SetLocation(LineIndex, WordIndex: Integer; OwnerNode: TTreeNode): PWordLocation;
begin
  GetMem(Result, SizeOf(Result));

  Result^.LineIdx := LineIndex;
  Result^.WordIdx := WordIndex;

  FLines[LineIndex].Words[WordIndex].Node := OwnerNode;
end;

function TOcrLine.GetWordsCount: Integer;
begin
  Result := Length(Self.Words);
end;

end.
