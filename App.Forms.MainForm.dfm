object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Windows UWP OCR Demo'
  ClientHeight = 606
  ClientWidth = 986
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 15
  object Splitter1: TSplitter
    Left = 385
    Top = 0
    Height = 606
    ResizeStyle = rsUpdate
    ExplicitLeft = 456
    ExplicitTop = 304
    ExplicitHeight = 100
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 385
    Height = 606
    Align = alLeft
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      385
      606)
    object GroupBox1: TGroupBox
      Left = 8
      Top = 47
      Width = 371
      Height = 553
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = 'OCR'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      DesignSize = (
        371
        553)
      object Label1: TLabel
        Left = 11
        Top = 24
        Width = 55
        Height = 15
        Caption = 'Language:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object Label3: TLabel
        Left = 11
        Top = 167
        Width = 149
        Height = 15
        Caption = 'Recognized lines and words:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 11
        Top = 530
        Width = 108
        Height = 15
        Anchors = [akLeft, akBottom]
        Caption = 'Text angle (degrees):'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowFrame
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ExplicitTop = 548
      end
      object lblTextAngle: TLabel
        Left = 125
        Top = 530
        Width = 5
        Height = 15
        Anchors = [akLeft, akBottom]
        Caption = '-'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowFrame
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ExplicitTop = 548
      end
      object Label4: TLabel
        Left = 11
        Top = 113
        Width = 183
        Height = 15
        Caption = 'Engine maximum demension (px):'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowFrame
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object lblMaxDemension: TLabel
        Left = 203
        Top = 113
        Width = 5
        Height = 15
        Caption = '-'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowFrame
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 11
        Top = 134
        Width = 124
        Height = 15
        Caption = 'Loaded image size (px):'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowFrame
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object lblImageSizes: TLabel
        Left = 203
        Top = 134
        Width = 5
        Height = 15
        Caption = '-'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowFrame
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object btnRecognize: TButton
        Left = 11
        Top = 74
        Width = 348
        Height = 33
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Recognize text'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = btnRecognizeClick
      end
      object cbLangs: TComboBox
        Left = 11
        Top = 45
        Width = 348
        Height = 23
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object TreeView1: TTreeView
        Left = 11
        Top = 188
        Width = 348
        Height = 336
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        HideSelection = False
        Indent = 19
        ParentFont = False
        TabOrder = 2
        OnChange = TreeView1Change
      end
    end
    object panelLoadButtons: TGridPanel
      Left = 8
      Top = 8
      Width = 371
      Height = 33
      Anchors = [akLeft, akTop, akRight]
      BevelOuter = bvNone
      ColumnCollection = <
        item
          Value = 50.000000000000000000
        end
        item
          Value = 50.000000000000000000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = btnLoadFromFile
          Row = 0
        end
        item
          Column = 1
          Control = btnLoadFromClipbrd
          Row = 0
        end>
      RowCollection = <
        item
          Value = 100.000000000000000000
        end>
      TabOrder = 1
      object btnLoadFromFile: TButton
        Left = 0
        Top = 0
        Width = 186
        Height = 33
        Align = alClient
        Caption = 'Load From File'#8230
        TabOrder = 0
        OnClick = btnLoadFromFileClick
      end
      object btnLoadFromClipbrd: TButton
        Left = 186
        Top = 0
        Width = 185
        Height = 33
        Align = alClient
        Caption = 'Paste From Clipboard'
        TabOrder = 1
        OnClick = btnLoadFromClipbrdClick
      end
    end
  end
  object OcrScrollBox: TScrollBox
    Left = 388
    Top = 0
    Width = 598
    Height = 606
    HorzScrollBar.Increment = 59
    HorzScrollBar.Tracking = True
    VertScrollBar.Increment = 57
    VertScrollBar.Tracking = True
    Align = alClient
    BevelInner = bvNone
    BevelKind = bkSoft
    BorderStyle = bsNone
    Color = clWindowFrame
    ParentColor = False
    TabOrder = 1
    object PaintBox1: TPaintBox
      Left = 0
      Top = 0
      Width = 289
      Height = 481
      OnClick = PaintBox1Click
      OnMouseDown = PaintBox1MouseDown
      OnMouseMove = PaintBox1MouseMove
      OnMouseUp = PaintBox1MouseUp
      OnPaint = PaintBox1Paint
    end
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 40
    Top = 352
  end
end
