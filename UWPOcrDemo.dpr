program UWPOcrDemo;

uses
  Vcl.Forms,
  App.Forms.MainForm in 'App.Forms.MainForm.pas' {MainForm} ,
  UWP.OcrEngine in 'UWP.OcrEngine.pas',
  App.DataManager in 'App.DataManager.pas',
  Shell.Shcore in 'Shell.Shcore.pas',
  App.Utils in 'App.Utils.pas';

{$R *.res}

begin

{$IFDEF DEBUG}

  ReportMemoryLeaksOnShutdown := True;

{$ENDIF}

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;

end.
