
unit diagnostics;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  lsp, basic;

type

  { TPublishDiagnosticsParams }

  TPublishDiagnosticsParams = class(TPersistent)
  private
    fUri: TDocumentUri;
    fVersion: integer;
    fDiagnostics: TDiagnosticItems;
  published
    // The URI for which diagnostic information is reported.
    property uri: TDocumentUri read fUri write fUri;

    // The version number of the document the diagnostics are published for.
    // todo: this must be optional
    //property version: integer read fVersion write fVersion;

    // An array of diagnostic information items.
    property diagnostics: TDiagnosticItems read fDiagnostics write fDiagnostics;
  public
    procedure AfterConstruction; override;
  end;

  { TPublishDiagnostics }

  TPublishDiagnostics = class(specialize TLSPNotification<TPublishDiagnosticsParams>)
    //procedure Process(var Params : TPublishDiagnosticsParams); override;
  end;

implementation


{ TPublishDiagnosticsParams }

procedure TPublishDiagnosticsParams.AfterConstruction;
begin
  diagnostics := TDiagnosticItems.Create;
  inherited;
end;


procedure PublishDiagnostic(fileName: string; line, column: integer);
var
  notification: TPublishDiagnostics;
  params: TPublishDiagnosticsParams;
  diagnostic: TDiagnostic;
begin
  params := TPublishDiagnosticsParams.Create;
  params.uri := PathToURI(fileName);
  diagnostic := TDiagnostic(params.diagnostics.Add);
  with diagnostic do
    begin
      range := TRange.Create(line, column);
      severity := TDiagnosticSeverity.Information;
      code := '100';
      source := 'Free Pascal Compiler';
      message := 'This is a diagnostic hint';
      tags := [];
      relatedInformation := nil;
    end;
end;

//procedure TPublishDiagnostics.Process(var Params : TPublishDiagnosticsParams);
//begin with Params do
//end;

initialization
  LSPHandlerManager.RegisterHandler('textDocument/publishDiagnostics', TPublishDiagnostics);
end.