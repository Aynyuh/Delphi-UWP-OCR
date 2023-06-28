unit App.Utils;

interface

uses Winapi.ActiveX, Winapi.CommonTypes, Vcl.AxCtrls, Vcl.Graphics, Shell.Shcore, System.Win.ComObj, Winapi.Windows,
  system.SysUtils, System.Types, Math, Vcl.Controls;

type
  TPolyRectF = array [0 .. 3] of TPointF;

  // we need subclass TOleStream to get access to protected method GetIStream
  TSubOleStream = class(TOleStream)
  end;

procedure EnableControl(Control: TControl; Enabled: Boolean = True);
procedure EnableControls(Controls: array of TControl; Enabled: Boolean = True);

/// <summary>Create IRandomAccessStream for a given Bitmap.</summary>
/// <param name="AGraphic">TGraphic to create IRandomAccessStream for.</param>
function GetRandomAccessStreamFromBitmap(AGraphic: TGraphic): IRandomAccessStream;

/// <summary>Format number using user's regional settings.</summary>
function FormatNumber(ANumber: Integer): string; overload;
/// <summary>Format number using user's regional settings.</summary>
function FormatNumber(const ANumberStr: string): string; overload;

/// <summary>Calculate minimum bounding rectangle for 4 points on plain aka "rotated rectangle".</summary>
function CalcMBR(const APoints: TPolyRectF): TRectF; inline;

/// <summary>Rotate point at specific center point.</summary>
/// <param name="AAngle">Angle in radians for ratation.</param>
function RotatePoint(const APoint: TPointF; const ACenter: TPointF; AAngle: Double): TPointF;

/// <summary>Rotate array of points at specific center point.</summary>
/// <param name="AAngle">Angle in radians for ratation.</param>
procedure RotatePoints(var APoints: TPolyRectF; const ACenter: TPointF; AAngle: Double);

function SHCreateMemStream(pInit: PByte; cbInit: Cardinal): Pointer; stdcall;
  external 'shlwapi.dll' name 'SHCreateMemStream';

implementation


procedure EnableControl(Control: TControl; Enabled: Boolean = True);

  procedure _EnableChildControls(Parent: TWinControl; Enabled: Boolean);
  var
    Ctl: TControl;
  begin
    for var i := 0 to Parent.ControlCount - 1 do
    begin
      Ctl := Parent.Controls[i];
      Ctl.Enabled := Enabled;
      if Ctl is TWinControl then
        _EnableChildControls(TWinControl(Ctl), Enabled);
    end;
  end;

begin
  Control.Enabled := Enabled;
  if Control is TWinControl then
    _EnableChildControls(TWinControl(Control), Enabled);
end;

procedure EnableControls(Controls: array of TControl; Enabled: Boolean = True);
begin
  for var c in Controls do
    EnableControl(c, Enabled);
end;

function FormatNumber(ANumber: Integer): string;
begin
  Result := FormatNumber(IntToStr(ANumber));
end;

function FormatNumber(const ANumberStr: string): string;
var
  sLen: Integer;
begin
  sLen := GetNumberFormatEx(PChar(LOCALE_NAME_USER_DEFAULT), 0, PChar(ANumberStr), nil, nil, 0);
  SetLength(Result, Pred(sLen));

  if sLen > 1 then
    GetNumberFormatEx(PChar(LOCALE_NAME_USER_DEFAULT), 0, PChar(ANumberStr), nil, PChar(Result), sLen);
end;

function GetRandomAccessStreamFromBitmap(AGraphic: TGraphic): IRandomAccessStream;
var
  oleStream: TSubOleStream;
  stream: IStream;
  pStream: Pointer;
begin
  // TODO: You also can use CreateStreamOnHGlobal(0, True, s) to allocate IStream
  pStream := SHCreateMemStream(nil, 0);
  stream := IStream(pStream);

  oleStream := TSubOleStream.Create(stream);
  AGraphic.SaveToStream(oleStream);
  OleCheck(CreateRandomAccessStreamOverStream(oleStream.GetIStream, BSOS_DEFAULT, IRandomAccessStream, Result));
  oleStream.Free;
end;

function CalcMBR(const APoints: TPolyRectF): TRectF; inline;
var
  // p1, p2, p3, p4: TPointF;
  minx, miny, maxx, maxy: Single;
begin
  // p1 := TPointF.Create(APoints[0].X, APoints[0].Y);
  // p2 := TPointF.Create(APoints[1].X, APoints[1].Y);
  // p3 := TPointF.Create(APoints[2].X, APoints[2].Y);
  // p4 := TPointF.Create(APoints[3].X, APoints[3].Y);
  //
  // minx := Trunc(Min(Min(p1.X, p2.X), Min(p3.X, p4.X)));
  // miny := Trunc(Min(Min(p1.Y, p2.Y), Min(p3.Y, p4.Y)));
  // maxx := Trunc(Max(Max(p1.X, p2.X), Max(p3.X, p4.X)));
  // maxy := Trunc(Max(Max(p1.Y, p2.Y), Max(p3.Y, p4.Y)));

  minx := Trunc(Min(Min(APoints[0].X, APoints[1].X), Min(APoints[2].X, APoints[3].X)));
  miny := Trunc(Min(Min(APoints[0].Y, APoints[1].Y), Min(APoints[2].Y, APoints[3].Y)));
  maxx := Trunc(Max(Max(APoints[0].X, APoints[1].X), Max(APoints[2].X, APoints[3].X)));
  maxy := Trunc(Max(Max(APoints[0].Y, APoints[1].Y), Max(APoints[2].Y, APoints[3].Y)));

  Result.TopLeft := TPointF.Create(minx, miny);
  Result.BottomRight := TPointF.Create(maxx, maxy);
end;

function RotatePoint(const APoint: TPointF; const ACenter: TPointF; AAngle: Double): TPointF;
begin
  Result := APoint - ACenter;
  Result := Result.Rotate(AAngle);
  Result := Result + ACenter;
end;

procedure RotatePoints(var APoints: TPolyRectF; const ACenter: TPointF; AAngle: Double);
begin
  for var i := 0 to High(APoints) do
    APoints[i] := RotatePoint(APoints[i], ACenter, AAngle);
end;

end.
