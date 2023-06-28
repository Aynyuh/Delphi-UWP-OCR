unit UWP.OcrEngine;

interface

uses
  System.Win.WinRT, System.Types, Winapi.WinRT, Winapi.CommonTypes, Winapi.Globalization, Winapi.GraphicsRT,
  Winapi.ActiveX, Winapi.SystemRT;

type
  IOcrEngine = interface;

  IOcrResult = interface;

  IOcrWord = interface;
  PIOcrWord = ^IOcrWord;

  IOcrLine = interface;
  PIOcrLine = ^IOcrLine;

  IBitmapDecoderStatics = interface;

  Imaging_IBitmapDecoder = interface;

  IAsyncOperation_1__Ocr_IOcrResult = interface;

  IAsyncOperation_1__Imaging_IBitmapDecoder = interface;

  Imaging_IBitmapCodecInformation = interface;
  PImaging_IBitmapCodecInformation = ^Imaging_IBitmapCodecInformation;

  // +
  // Windows.Foundation.Collections.IVectorView<Windows.Graphics.Imaging.BitmapCodecInformation>
  IVectorView_1__BitmapCodecInformation = interface(IInspectable)
    ['{97DFDE96-FF1D-5AA1-863A-90116A31B86B}']
    function GetAt(index: Cardinal): Imaging_IBitmapCodecInformation; safecall;
    function get_Size: Cardinal; safecall;
    function IndexOf(value: Imaging_IBitmapCodecInformation; out index: Cardinal): Boolean; safecall;
    function GetMany(startIndex: Cardinal; itemsSize: Cardinal; items: PImaging_IBitmapCodecInformation)
      : Cardinal; safecall;
    property Size: Cardinal read get_Size;
  end;

  // +
  // Windows.Foundation.IAsyncOperationCompletedHandler<Windows.Graphics.Imaging.BitmapDecoder>
  IAsyncOperationCompletedHandler_1__Imaging_IBitmapDecoder = interface(IUnknown)
    ['{bb6514f2-3cfb-566f-82bc-60aabd302d53}']
    procedure Invoke(asyncInfo: IAsyncOperation_1__Imaging_IBitmapDecoder; asyncStatus: asyncStatus); safecall;
  end;

  // +
  // Windows.Foundation.IAsyncOperation<Windows.Graphics.Imaging.BitmapDecoder>
  IAsyncOperation_1__Imaging_IBitmapDecoder = interface(IInspectable)
    ['{AA94D8E9-CAEF-53F6-823D-91B6E8340510}']
    procedure put_Completed(handler: IAsyncOperationCompletedHandler_1__Imaging_IBitmapDecoder); safecall;
    function get_Completed: IAsyncOperationCompletedHandler_1__Imaging_IBitmapDecoder; safecall;
    function GetResults: Imaging_IBitmapDecoder; safecall;
    property Completed: IAsyncOperationCompletedHandler_1__Imaging_IBitmapDecoder read get_Completed
      write put_Completed;
  end;

  // -
  // Windows.Foundation.IAsyncOperation<Windows.Graphics.Imaging.ImageStream>
  IAsyncOperation_1__Imaging_ImageStream = interface(IInspectable)
    ['{684165BE-0011-56D6-BEBF-430016D51B7A}']
  end;

  // -
  // Windows.Foundation.IAsyncOperation<Windows.Graphics.Imaging.BitmapFrame>
  IAsyncOperation_1__Imaging_BitmapFrame = interface(IInspectable)
    ['{CB1483D1-1464-5BF9-9346-D537735DFBD6}']
  end;

  // -
  // Windows.Graphics.Imaging.IBitmapPropertiesView
  Imaging_IBitmapPropertiesView = interface(IInspectable)
    ['{7E0FE87A-3A70-48F8-9C55-196CF5A545F5}']
  end;

  // -
  // Windows::Graphics::Imaging::IBitmapCodecInformation
  Imaging_IBitmapCodecInformation = interface(IInspectable)
    ['{400CAAF2-C4B0-4392-A3B0-6F6F9BA95CB4}']
  end;

  // -
  // Windows.Foundation.IAsyncOperation<Windows.Graphics.Imaging.PixelDataProvider>
  IAsyncOperation_1__Imaging_PixelDataProvider = interface(IInspectable)
    ['{8C2DFEB0-6C22-5863-88D8-85C1FBC75697}']
  end;

  // -
  // Windows::Graphics::Imaging::IBitmapTransform
  Imaging_IBitmapTransform = interface(IInspectable)
    ['{AE755344-E268-4D35-ADCF-E995D31A8D34}']
  end;

  // +
  IAsyncOperationCompletedHandler_1__IOcrResult = interface(IUnknown)
    ['{989c1371-444a-5e7e-b197-9eaaf9d2829a}']
    procedure Invoke(asyncInfo: IAsyncOperation_1__Ocr_IOcrResult; asyncStatus: asyncStatus); safecall;
  end;

  // +
  // Windows.Foundation.IAsyncOperation<Windows.Media.Ocr.OcrResult>
  IAsyncOperation_1__Ocr_IOcrResult = interface(IInspectable)
    ['{C7D7118E-AE36-59C0-AC76-7BADEE711C8B}']
    procedure put_Completed(handler: IAsyncOperationCompletedHandler_1__IOcrResult); safecall;
    function get_Completed: IAsyncOperationCompletedHandler_1__IOcrResult; safecall;
    function GetResults: IOcrResult; safecall;
    property Completed: IAsyncOperationCompletedHandler_1__IOcrResult read get_Completed
      write put_Completed;
  end;

  // +
  // Windows.Foundation.Collections.IVectorView`1<Windows::Media::Ocr::OcrLine>
  IVectorView_1__Ocr_IOcrLine = interface(IInspectable)
    ['{60C76EAC-8875-5DDB-A19B-65A3936279EA}']
    function GetAt(index: Cardinal): IOcrLine; safecall;
    function get_Size: Cardinal; safecall;
    function IndexOf(value: IOcrLine; out index: Cardinal): Boolean; safecall;
    function GetMany(startIndex: Cardinal; itemsSize: Cardinal; items: PIOcrLine): Cardinal; safecall;
    property Size: Cardinal read get_Size;
  end;

  // +
  // Windows.Foundation.Collections.IVectorView<Windows::Media::Ocr::OcrWord>
  IVectorView_1__Ocr_IOcrWord = interface(IInspectable)
    ['{805a60c7-df4f-527c-86b2-e29e439a83d2}']
    function GetAt(index: Cardinal): IOcrWord; safecall;
    function get_Size: Cardinal; safecall;
    function IndexOf(value: IOcrWord; out index: Cardinal): Boolean; safecall;
    function GetMany(startIndex: Cardinal; itemsSize: Cardinal; items: PIOcrWord): Cardinal; safecall;
    property Size: Cardinal read get_Size;
  end;

  // +
  [WinRTClassName('Windows.Graphics.Imaging.BitmapDecoder')]
  IBitmapDecoderStatics = interface(IInspectable)
    ['{438CCB26-BCEF-4E95-BAD6-23A822E58D01}']
    function get_BmpDecoderId: TGUID;
      safecall;
    function get_JpegDecoderId: TGUID; safecall;
    function get_PngDecoderId: TGUID; safecall;
    function get_TiffDecoderId: TGUID; safecall;
    function get_GifDecoderId: TGUID; safecall;
    function get_JpegXRDecoderId: TGUID; safecall;
    function get_IcoDecoderId: TGUID; safecall;
    function GetDecoderInformationEnumerator: IVectorView_1__BitmapCodecInformation; safecall;
    function CreateAsync(stream: IRandomAccessStream): IAsyncOperation_1__Imaging_IBitmapDecoder; safecall; overload;
    function CreateAsync(decoderId: TGUID; stream: IRandomAccessStream): IAsyncOperation_1__Imaging_IBitmapDecoder;
      safecall; overload;
  end;

  // +
  // Windows.Graphics.Imaging.IBitmapDecoder
  [WinRTClassName('Windows.Graphics.Imaging.BitmapDecoder')]
  Imaging_IBitmapDecoder = interface(IInspectable)
    ['{ACEF22BA-1D74-4C91-9DFC-9620745233E6}']
    function get_BitmapContainerProperties: Imaging_IBitmapPropertiesView; safecall;
    function get_DecoderInformation: Imaging_IBitmapCodecInformation; safecall;
    function get_FrameCount: UINT32; safecall;
    function GetPreviewAsync: IAsyncOperation_1__Imaging_ImageStream; safecall;
    function GetFrameAsync(frameIndex: UINT32): IAsyncOperation_1__Imaging_BitmapFrame; safecall;
  end;

  // +
  IBitmapFrame = interface(IInspectable)
    ['{72A49A1C-8081-438D-91BC-94ECFC8185C6}']
    function GetThumbnailAsync: IAsyncOperation_1__Imaging_ImageStream; safecall;
    function get_BitmapProperties: Imaging_IBitmapPropertiesView; safecall;
    function get_BitmapPixelFormat: Imaging_BitmapPixelFormat; safecall;
    function get_BitmapAlphaMode: Imaging_BitmapAlphaMode; safecall;
    function get_DpiX: Double; safecall;
    function get_DpiY: Double; safecall;
    function get_PixelWidth: UINT32; safecall;
    function get_PixelHeight: UINT32; safecall;
    function get_OrientedPixelWidth: UINT32; safecall;
    function get_OrientedPixelHeight: UINT32; safecall;
    function GetPixelDataAsync: IAsyncOperation_1__Imaging_PixelDataProvider; safecall; overload;
    function GetPixelDataAsync(pixelFormat: Imaging_BitmapPixelFormat; alphaMode: Imaging_BitmapAlphaMode;
      transform: Imaging_IBitmapTransform; exifOrientationMode: Imaging_ExifOrientationMode;
      colorManagementMode: Imaging_ColorManagementMode): IAsyncOperation_1__Imaging_PixelDataProvider; safecall;
      overload;
  end;

  // +
  IBitmapFrameWithSoftwareBitmap = interface(IInspectable)
    ['{fe287c9a-420c-4963-87ad-691436e08383}']
    function GetSoftwareBitmapAsync: IAsyncOperation_1__Imaging_ISoftwareBitmap; safecall; overload;
    function GetSoftwareBitmapAsync(pixelFormat: Imaging_BitmapPixelFormat; alphaMode: Imaging_BitmapAlphaMode)
      : IAsyncOperation_1__Imaging_ISoftwareBitmap; safecall; overload;
    function GetSoftwareBitmapAsync(pixelFormat: Imaging_BitmapPixelFormat; alphaMode: Imaging_BitmapAlphaMode;
      transform: Imaging_IBitmapTransform; exifOrientationMode: Imaging_ExifOrientationMode;
      colorManagementMode: Imaging_ColorManagementMode)
      : IAsyncOperation_1__Imaging_ISoftwareBitmap; safecall; overload;
  end;

  // +
  // Windows.Media.Ocr.OcrEngine
  [WinRTClassName('Windows.Media.Ocr.OcrEngine')]
  IOcrEngineStatics = interface(IInspectable)
    ['{5BFFA85A-3384-3540-9940-699120D428A8}']
    function get_MaxImageDimension: UINT32; safecall;
    function get_AvailableRecognizerLanguages: IVectorView_1__ILanguage; safecall;
    function IsLanguageSupported(language: ILanguage): ByteBool; safecall;
    function TryCreateFromLanguage(language: ILanguage): IOcrEngine; safecall;
    function TryCreateFromUserProfileLanguages: IOcrEngine; safecall;
  end;

  // +
  // Windows.Media.Ocr.OcrEngine
  [WinRTClassName('Windows.Media.Ocr.OcrEngine')]
  IOcrEngine = interface(IInspectable)
    ['{5A14BC41-5B76-3140-B680-8825562683AC}']
    function RecognizeAsync(bitmap: Imaging_ISoftwareBitmap): IAsyncOperation_1__Ocr_IOcrResult; safecall;
    function get_RecognizerLanguage: ILanguage; safecall;
  end;

  // +
  // Windows.Media.Ocr.OcrResult
  [WinRTClassName('Windows.Media.Ocr.OcrResult')]
  IOcrResult = interface(IInspectable)
    ['{9BD235B2-175B-3D6A-92E2-388C206E2F63}']
    function get_Lines: IVectorView_1__Ocr_IOcrLine; safecall;
    function get_TextAngle: IReference_1__Double; safecall;
    function get_Text: HSTRING; safecall;
  end;

  // +
  // Windows.Media.Ocr.OcrLine
  [WinRTClassName('Windows.Media.Ocr.OcrLine')]
  IOcrLine = interface(IInspectable)
    ['{0043A16F-E31F-3A24-899C-D444BD088124}']
    function get_Words: IVectorView_1__Ocr_IOcrWord; safecall;
    function get_Text: HSTRING; safecall;
  end;

  // +
  // Windows.Media.Ocr.OcrWord
  [WinRTClassName('Windows.Media.Ocr.OcrWord')]
  IOcrWord = interface(IInspectable)
    ['{3C2A477A-5CD9-3525-BA2A-23D1E0A68A1D}']
    function get_BoundingRect: TRectF; safecall;
    function get_Text: HSTRING; safecall;
  end;

  TWinRTBitmap = class(TWinRTGenericImportS<IBitmapDecoderStatics>)
  end;

  TWinRTOcrEngine = class(TWinRTGenericImportS<IOcrEngineStatics>)
  end;

implementation

end.
