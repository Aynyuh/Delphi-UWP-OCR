unit Shell.Shcore;

interface

uses Winapi.ActiveX, Winapi.CommonTypes;

type

{$Z+} // {$MINENUMSIZE 4}

  BSOS_OPTIONS = (
    // when creating a byte seeker over a stream, base randomaccessstream behavior on the STGM mode from IStream::Stat.
    BSOS_DEFAULT = 0,

    // in addition, utilize IDestinationStreamFactory::GetDestinationStream.
    BSOS_PREFERDESTINATIONSTREAM);

  TBSOSOptions = BSOS_OPTIONS;

{$Z-} // {$MINENUMSIZE 1}

function CreateRandomAccessStreamOnFile(filePath: PWideChar; accessMode: FileAccessMode; const riid: TGUID; out ppv)
  : HRESULT; stdcall; external 'SHCore.dll' delayed;

function CreateRandomAccessStreamOverStream(stream: IStream; options: TBSOSOptions; const riid: TGUID; out ppv)
  : HRESULT; stdcall; external 'SHCore.dll' delayed;

implementation

end.
