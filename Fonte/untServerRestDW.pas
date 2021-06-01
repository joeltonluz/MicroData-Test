unit untServerRestDW;

interface

uses
  System.SysUtils, System.Classes, uDWDataModule, uDWAbout, uRESTDWServerEvents,
  uDWJsonObject, System.json;

type
  TdtmServerRestDW = class(TServerMethodDataModule)
    DWEvents: TDWServerEvents;
    procedure DWEventsEventsclientesReplyEvent(var Params: TDWParams;
      var Result: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dtmServerRestDW: TdtmServerRestDW;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses dtmPrincipal, untCliente;

{$R *.dfm}

procedure TdtmServerRestDW.DWEventsEventsclientesReplyEvent(var Params: TDWParams; var Result: string);
var
  PNome, PErro: String;
  Cliente: TCliente;
  Json: TJsonObject;
begin
  try
    PNome := AnsiUpperCase(Params.ItemsString['nome'].AsString);

    Json := TJSONObject.Create;

    Cliente := TCliente.Create(PrincipalM.connPrincipal);
    Cliente.Nome := PNome;

    if not Cliente.GetCliente(PErro) then
    begin
      Json.AddPair('Erro',PErro);
    end else begin
      Json.AddPair('ID',IntToStr(Cliente.ID));
      Json.AddPair('Nome',Cliente.Nome);
      Json.AddPair('Cep',Cliente.Cep);
      Json.AddPair('Logradouro',Cliente.Logradouro);
      Json.AddPair('Numero',Cliente.Numero);
      Json.AddPair('Complemento',Cliente.Complemento);
      Json.AddPair('Cidade',Cliente.Cidade);
      Json.AddPair('IbgeCidade',Cliente.IbgeCidade);
      Json.AddPair('SiglaUf',Cliente.SiglaUf);
      Json.AddPair('IbgeUf',Cliente.IbgeUf);
    end;

    Result := Json.ToString;


  finally
    FreeAndNil(Cliente);
  end;
end;

end.
