unit App.Forms.MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtDlgs, Vcl.ExtCtrls, Winapi.Globalization, System.Win.WinRT, ComObj, Winapi.WinRT,
  Winapi.SystemRT, Winapi.WinRT.Utils, Vcl.Imaging.pngimage, Vcl.Imaging.jpeg, Vcl.Imaging.GIFImg, Math, System.Types,
  Winapi.GDIPOBJ, Winapi.GDIPAPI, Math.Vectors, Vcl.ComCtrls, App.DataManager, UWP.OcrEngine, Shell.Shcore, Vcl.Clipbrd,
  App.Utils, Winapi.GraphicsRT, Winapi.CommonTypes;

type
  TMainForm = class(TForm)

{$REGION 'Designer Fields'}

    OpenPictureDialog1: TOpenPictureDialog;
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    btnRecognize: TButton;
    cbLangs: TComboBox;
    PaintBox1: TPaintBox;
    OcrScrollBox: TScrollBox;
    Label3: TLabel;
    TreeView1: TTreeView;
    Splitter1: TSplitter;
    Label2: TLabel;
    lblTextAngle: TLabel;
    Label4: TLabel;
    lblMaxDemension: TLabel;
    Label5: TLabel;
    lblImageSizes: TLabel;
    panelLoadButtons: TGridPanel;
    btnLoadFromFile: TButton;
    btnLoadFromClipbrd: TButton;
    procedure btnLoadFromFileClick(Sender: TObject);
    procedure btnRecognizeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure PaintBox1Click(Sender: TObject);
    procedure btnLoadFromClipbrdClick(Sender: TObject);

{$ENDREGION}

  private
    { Private declarations }
    { Keeps original image from file or from clipboard }
    g_srcPic: TPicture;
    { Bitmap for drawing and display in the PaintBox }
    g_dispImg: TBitmap;
    { OCR engine detected rotation angle of recognized image }
    g_nOcrImageAngle: Double;
    g_DataManager: TTreeViewDataManager;

    { Record to store the mouse information }
    dragInfo: record
      isDragging: Boolean;
      wasDragged: Boolean;
      dragPoint: TPoint;
    end;

    procedure InitProgram;
    procedure InitLanguageList;
    procedure InitUI;

    // procedure DrawWordsRects(ALine: Integer = -1; AWord: Integer = -1);
    procedure DrawWordsRects(ASelectedWordLocation: PWordLocation);
    procedure FreeFormResources;
    function RecognizeImage(AStream: IRandomAccessStream; ALangTag: string): IOcrResult;
    procedure ScrollInView(const ARect: TRectF);
  protected
    procedure CreateWnd; override;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.CreateWnd;
begin
  inherited;
  DoubleBuffered := True;
end;

procedure TMainForm.btnLoadFromFileClick(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
  begin
    if not Assigned(g_srcPic) then
      g_srcPic := TPicture.Create;

    g_srcPic.LoadFromFile(OpenPictureDialog1.FileName);

    InitProgram;
  end;
end;

procedure TMainForm.btnRecognizeClick(Sender: TObject);
var
  oOcrResult: IOcrResult;
  oRandStream: IRandomAccessStream;
begin
  // DONE: Make "recognize" button disabled while ocr is working

  EnableControls([btnRecognize, panelLoadButtons], False);

  oRandStream := GetRandomAccessStreamFromBitmap(g_srcPic.Graphic);
  oOcrResult := RecognizeImage(oRandStream, cbLangs.Items[cbLangs.ItemIndex]);

  if oOcrResult <> nil then
  begin
    g_nOcrImageAngle := 0;
    g_nOcrImageAngle := oOcrResult.get_TextAngle.Value;

    lblTextAngle.Caption := Format('%f', [g_nOcrImageAngle]);

    g_DataManager.InitWithResult(oOcrResult);
    g_DataManager.DisplayData();
    DrawWordsRects(nil);
    PaintBox1.Invalidate();
  end;

  EnableControls([btnRecognize, panelLoadButtons]);
end;

procedure TMainForm.btnLoadFromClipbrdClick(Sender: TObject);
begin
  if not Assigned(g_srcPic) then
    g_srcPic := TPicture.Create;

  g_srcPic.LoadFromClipboardFormat(CF_BITMAP, ClipBoard.GetAsHandle(cf_Bitmap), 0);

  InitProgram;
end;

procedure TMainForm.DrawWordsRects(ASelectedWordLocation: PWordLocation);
var
  bSelected: Boolean;
  word: POcrWord;

  gpCanvas: TGPGraphics;
  solidPen: TGPPen;
  rotationMatrix: TGPMatrix;

  nLine, nWord: Integer;
begin
  nLine := -1;
  nWord := -1;

  if ASelectedWordLocation <> nil then
  begin
    nLine := ASelectedWordLocation^.LineIdx;
    nWord := ASelectedWordLocation^.WordIdx;
  end;

  { Draw original image first }
  g_dispImg.Canvas.Draw(0, 0, g_srcPic.Graphic);

  { Draw angled by g_nOcrImageAngle rectangles and selected rectangle using GDI+ }

  // gp matrix with rotation at image center
  rotationMatrix := TGPMatrix.Create;
  rotationMatrix.RotateAt(g_nOcrImageAngle, MakePoint(g_dispImg.Width / 2.0, g_dispImg.Height / 2.0));

  // gp canvas
  gpCanvas := TGPGraphics.Create(g_dispImg.Canvas.Handle);
  gpCanvas.SetSmoothingMode(SmoothingModeAntiAlias);
  gpCanvas.SetTransform(rotationMatrix);

  // gp pen
  solidPen := TGPPen.Create(aclViolet);
  solidPen.SetStartCap(LineCapRound);
  solidPen.SetEndCap(LineCapRound);

  for var li := 0 to g_DataManager.LinesCount - 1 do
    for var wi := 0 to g_DataManager.Line[li].WordsCount - 1 do
    begin
      bSelected := (nLine = li) and (nWord = wi);

      solidPen.SetColor(IfThen(bSelected, aclRed, aclSkyBlue));
      solidPen.SetWidth(IfThen(bSelected, 2, 1));

      word := g_DataManager.GetWord(li, wi);
      gpCanvas.DrawRectangle(solidPen, TGPRectF(word^.Rect));
    end;

  solidPen.Free;
  gpCanvas.Free;
  rotationMatrix.Free;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeFormResources;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  EnableControl(GroupBox1, False);
end;

procedure TMainForm.FreeFormResources;
begin
  g_srcPic.Free;
  g_dispImg.Free;
  g_DataManager.Free;
end;

procedure TMainForm.InitProgram;
begin
  if not Assigned(g_DataManager) then
    g_DataManager := TTreeViewDataManager.Create(TreeView1)
  else
    g_DataManager.ClearTreeView;

  PaintBox1.Width := g_srcPic.Width;
  PaintBox1.Height := g_srcPic.Height;

  if not Assigned(g_dispImg) then
    g_dispImg := TBitmap.Create;

  g_dispImg.Assign(g_srcPic.Graphic);

  InitLanguageList;
  InitUI;
end;

procedure TMainForm.InitUI;
var
  sImgMaxSize: string;
begin
  sImgMaxSize := FormatNumber(TWinRTOcrEngine.Statics.get_MaxImageDimension);
  lblMaxDemension.Caption := sImgMaxSize.Substring(0, sImgMaxSize.LastIndexOf(TFormatSettings.Create.DecimalSeparator));
  lblImageSizes.Caption := Format('%dx%d', [g_srcPic.Width, g_srcPic.Height]);

  if cbLangs.GetCount > 0 then
    cbLangs.ItemIndex := 0;

  EnableControl(GroupBox1);
  PaintBox1.Invalidate;
end;

procedure TMainForm.InitLanguageList;
var
  langsArray: IVectorView_1__HSTRING;
  lang: HSTRING;
  oLang: ILanguage;
begin
  cbLangs.Clear;

  langsArray := TUserProfile_GlobalizationPreferences.Statics.Languages;

  // TODO: Rewrite for usage with for-in loop
  for var i := 0 to langsArray.Size - 1 do
  begin
    lang := langsArray.GetAt(i);
    oLang := TLanguage.Factory.CreateLanguage(lang);

    if TWinRTOcrEngine.Statics.IsLanguageSupported(oLang) then
      cbLangs.Items.Add(lang.ToString);
  end;
end;

procedure TMainForm.PaintBox1Click(Sender: TObject);
var
  clickPoint, imgCenter, angledPoint: TPointF;
begin
  if dragInfo.wasDragged then
    Exit;

  if not Assigned(g_dispImg) then
    Exit;

  { Calculate click point by rotation in the opposite to Ocr angle }
  clickPoint := TPointF.Create(PaintBox1.ScreenToClient(Mouse.CursorPos));
  imgCenter := TPointF.Create(g_dispImg.Width / 2, g_dispImg.Height / 2);

  angledPoint := RotatePoint(clickPoint, imgCenter, DegToRad(-g_nOcrImageAngle));
  g_DataManager.TreeView.Select(g_DataManager.FindWordNodeAt(angledPoint));
end;

procedure TMainForm.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  with dragInfo do
  begin
    isDragging := True;
    wasDragged := False;
    dragPoint := Point(X, Y);
  end;
end;

procedure TMainForm.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if dragInfo.isDragging then
  begin
    OcrScrollBox.HorzScrollBar.Position := OcrScrollBox.HorzScrollBar.Position - (X - dragInfo.dragPoint.X);
    OcrScrollBox.VertScrollBar.Position := OcrScrollBox.VertScrollBar.Position - (Y - dragInfo.dragPoint.Y);

    dragInfo.wasDragged := (dragInfo.dragPoint.X <> X) or (dragInfo.dragPoint.Y <> Y);
  end;
end;

procedure TMainForm.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  dragInfo.isDragging := False;
end;

procedure TMainForm.PaintBox1Paint(Sender: TObject);
begin
  if Assigned(g_dispImg) then
    PaintBox1.Canvas.Draw(0, 0, g_dispImg);
end;

function TMainForm.RecognizeImage(AStream: IRandomAccessStream; ALangTag: string): IOcrResult;
var
  langTag: TWindowsString;
  oOcrEngine: IOcrEngine;
  oBitmapFrameWithSoftwareBitmap: IBitmapFrameWithSoftwareBitmap;

  oBitmapDecoder: Imaging_IBitmapDecoder;
  oBitmapDecoderAsyncDelegate: IAsyncOperation_1__Imaging_IBitmapDecoder;

  oSoftwareBitmap: Imaging_ISoftwareBitmap;
  oSoftwareBitmapAsyncDelegate: IAsyncOperation_1__Imaging_ISoftwareBitmap;

  oOcrResult: IOcrResult;
  oOcrResultAsyncDelegate: IAsyncOperation_1__Ocr_IOcrResult;
begin
  Result := nil;

  langTag := TWindowsString.Create(ALangTag);

  if not langTag.Valid then
    raise EArgumentException.Create('Cannot create WinRT string from string "' + ALangTag + '". ');

  try
    oOcrEngine := TWinRTOcrEngine.Statics.TryCreateFromLanguage(TLanguage.Factory.CreateLanguage(langTag));
  except
    on E: EOleException do
      raise EArgumentException.Create('Cannot create interface IOcrEngine from language tag "' + ALangTag + '". ' +
        E.Message);
  end;

  // TODO: You can use CreateRandomAccessStreamOnFile to get stream from on-disk file
  // OleCheck(CreateRandomAccessStreamOnFile(PWideChar(sFilename), FileAccessMode.Read, IRandomAccessStream, stream));

  oBitmapDecoderAsyncDelegate := TWinRTBitmap.Statics.CreateAsync(AStream);
  Await(oBitmapDecoderAsyncDelegate, Application.ProcessMessages);
  oBitmapDecoder := oBitmapDecoderAsyncDelegate.GetResults;

  // TODO: You can check maximum image dimension and compare with IOcrEngineStatics.get_MaxImageDimension
  // oBitmapDecoder.QueryInterface(IBitmapFrame, oBitmapFrame);
  // if (oBitmapFrame.get_PixelWidth or oBitmapFrame.get_PixelHeight) > IOcrEngineStatics.get_MaxImageDimension then Exit;

  if Succeeded(oBitmapDecoder.QueryInterface(IBitmapFrameWithSoftwareBitmap, oBitmapFrameWithSoftwareBitmap)) then
  begin
    oSoftwareBitmapAsyncDelegate := oBitmapFrameWithSoftwareBitmap.GetSoftwareBitmapAsync();
    Await(oSoftwareBitmapAsyncDelegate, Application.ProcessMessages);
    oSoftwareBitmap := oSoftwareBitmapAsyncDelegate.GetResults;

    oOcrResultAsyncDelegate := oOcrEngine.RecognizeAsync(oSoftwareBitmap);
    Await(oOcrResultAsyncDelegate, Application.ProcessMessages);
    oOcrResult := oOcrResultAsyncDelegate.GetResults;

    if oOcrResult.get_Lines.Size > 0 then
      Result := oOcrResult;
  end;
end;

procedure TMainForm.ScrollInView(const ARect: TRectF);
var
  r: TRectF;
  sb: TScrollBox;
  imgCenter: TPointF;
  mbrRect: TRect;
  poly: TPolyRectF;
begin
  r := ARect;
  sb := OcrScrollBox;

  // fix rect
  r.Right := r.Left + r.Right;
  r.Bottom := r.Top + r.Bottom;

  { ------------------------------ Calculate MBR ------------------------------- }
  imgCenter := TPointF.Create(g_dispImg.Width / 2, g_dispImg.Height / 2);

  poly[0] := TPointF.Create(r.Left, r.Top);
  poly[1] := TPointF.Create(r.Right, r.Top);
  poly[2] := TPointF.Create(r.Right, r.Bottom);
  poly[3] := TPointF.Create(r.Left, r.Bottom);

  RotatePoints(poly, imgCenter, DegToRad(g_nOcrImageAngle));

  mbrRect := CalcMBR(poly).Truncate;
  { ---------------------------------------------------------------------------- }

  if mbrRect.Top < sb.VertScrollBar.Position then
    // it's above view rect
    sb.VertScrollBar.Position := mbrRect.Top - sb.Margins.Top
  else if mbrRect.Bottom > sb.VertScrollBar.Position + sb.ClientHeight then
    // it's below view rect
    sb.VertScrollBar.Position := mbrRect.Bottom - sb.ClientHeight + sb.Margins.Bottom;

  if mbrRect.Left < sb.HorzScrollBar.Position then
    sb.HorzScrollBar.Position := mbrRect.Left - sb.Margins.Left
  else if mbrRect.Right > sb.HorzScrollBar.Position + sb.ClientWidth then
    sb.HorzScrollBar.Position := mbrRect.Right - sb.ClientWidth + sb.Margins.Right;
end;

procedure TMainForm.TreeView1Change(Sender: TObject; Node: TTreeNode);
var
  data: PWordLocation;
  word: POcrWord;
begin
  { Getting PWordLocation related to selected node and scroll it into view if found }

  data := g_DataManager.GetNodeData(Node);
  DrawWordsRects(data);

  if data <> nil then
  begin
    word := g_DataManager.GetWord(data^.LineIdx, data^.WordIdx);

    // if word <> nil then
    ScrollInView(word^.Rect);
  end;

  PaintBox1.Invalidate;
end;

end.
