unit uRESTDWBase;

{$I uRESTDW.inc}

{
  REST Dataware vers�o CORE.
  Criado por XyberX (Gilbero Rocha da Silva), o REST Dataware tem como objetivo o uso de REST/JSON
 de maneira simples, em qualquer Compilador Pascal (Delphi, Lazarus e outros...).
  O REST Dataware tamb�m tem por objetivo levar componentes compat�veis entre o Delphi e outros Compiladores
 Pascal e com compatibilidade entre sistemas operacionais.
  Desenvolvido para ser usado de Maneira RAD, o REST Dataware tem como objetivo principal voc� usu�rio que precisa
 de produtividade e flexibilidade para produ��o de Servi�os REST/JSON, simplificando o processo para voc� programador.

 Membros do Grupo :

 XyberX (Gilberto Rocha)    - Admin - Criador e Administrador do CORE do pacote.
 Ivan Cesar                 - Admin - Administrador do CORE do pacote.
 Joanan Mendon�a Jr. (jlmj) - Admin - Administrador do CORE do pacote.
 Giovani da Cruz            - Admin - Administrador do CORE do pacote.
 A. Brito                   - Admin - Administrador do CORE do pacote.
 Alexandre Abbade           - Admin - Administrador do desenvolvimento de DEMOS, coordenador do Grupo.
 Ari                        - Admin - Administrador do desenvolvimento de DEMOS, coordenador do Grupo.
 Alexandre Souza            - Admin - Administrador do Grupo de Organiza��o.
 Anderson Fiori             - Admin - Gerencia de Organiza��o dos Projetos
 Mizael Rocha               - Member Tester and DEMO Developer.
 Fl�vio Motta               - Member Tester and DEMO Developer.
 Itamar Gaucho              - Member Tester and DEMO Developer.
 Ico Menezes                - Member Tester and DEMO Developer.
}

interface

//Para saber a versao da IDE do Lazarus
//uses
//  LCLVersion;
//
//{$IF LCL_FullVersion >= 2000000}
//  {$DEFINE Something}
//{$IFEND}

Uses
     {$IFDEF FPC}
     SysUtils,                        Classes,            ServerUtils, {$IFDEF WINDOWS}Windows,{$ENDIF}
     IdContext, IdTCPConnection,      IdHTTPServer,       IdCustomHTTPServer,  IdSSLOpenSSL,    IdSSL,
     IdAuthentication,                IdTCPClient,        IdHTTPHeaderInfo,    IdComponent, IdBaseComponent,
     IdHTTP,                          uDWConsts, uDWConstsData,  IdMessageCoderMIME, IdMultipartFormData, IdMessageCoder,
     IdHashMessageDigest, IdHash,     IdMessage, uDWJSON, IdStack,    uDWJSONObject, IdGlobal, IdGlobalProtocols, IdURI,
     uSystemEvents, uDWConstsCharset, HTTPDefs,       LConvEncoding,      uDWAbout;
     {$ELSE}
     {$IF CompilerVersion <= 22}
     SysUtils, Classes, EncdDecd, SyncObjs,
      dwISAPIRunner, dwCGIRunner, IdHashMessageDigest,
     {$ELSE}
     System.SysUtils, System.Classes, system.SyncObjs, IdHashMessageDigest, IdHash,
     {$IF Defined(HAS_FMX)}
      {$IFDEF WINDOWS}
       dwISAPIRunner, dwCGIRunner,
      {$ELSE}
       {$IFNDEF APPLE}
        dwCGIRunner,
       {$ENDIF}
      {$ENDIF}
      {$ELSE}
       dwISAPIRunner, dwCGIRunner,
      {$IFEND}
     {$IFEND}
     ServerUtils, HTTPApp, uDWAbout, idSSLOpenSSL, IdStack, uDWConstsCharset,
     {$IFDEF WINDOWS} Windows, {$ENDIF} uDWConsts, uDWConstsData,       IdTCPClient,
     {$IF Defined(HAS_FMX)} System.IOUtils, System.json,{$ELSE} uDWJSON,{$IFEND} IdMultipartFormData,
     IdContext,             IdHTTPServer,        IdCustomHTTPServer,    IdSSL, IdURI,
     IdAuthentication,      IdHTTPHeaderInfo,    IdComponent, IdBaseComponent, IdTCPConnection,
     IdHTTP,                IdMessageCoder,      uDWJSONObject,
     uSystemEvents, IdMessageCoderMIME,    IdMessage,           IdGlobalProtocols,     IdGlobal;
     {$ENDIF}


Type
 TOnCreate          = Procedure (Sender            : TObject)             Of Object;
 TLastRequest       = Procedure (Value             : String)              Of Object;
 TLastResponse      = Procedure (Value             : String)              Of Object;
 TBeforeUseCriptKey = Procedure (Request           : String;
                                 Var Key           : String)              Of Object;
 TEventContext      = Procedure (AContext          : TIdContext;
                                 ARequestInfo      : TIdHTTPRequestInfo;
                                 AResponseInfo     : TIdHTTPResponseInfo) Of Object;
 TOnWork            = Procedure (ASender           : TObject;
                                 AWorkMode         : TWorkMode;
                                 AWorkCount        : Int64)               Of Object;
 TOnBeforeExecute   = Procedure (ASender           : TObject)             Of Object;

 TOnWorkBegin       = Procedure (ASender           : TObject;
                                 AWorkMode         : TWorkMode;
                                 AWorkCountMax     : Int64)               Of Object;
 TOnWorkEnd         = Procedure (ASender           : TObject;
                                 AWorkMode         : TWorkMode)           Of Object;
 TOnStatus          = Procedure (ASender           : TObject;
                                 Const AStatus     : TIdStatus;
                                 Const AStatusText : String)              Of Object;
 TCallBack          = Procedure (Json              : String;
                                 DWParams          : TDWParams) Of Object;
 TCallSendEvent     = Function  (EventData         : String;
                                 Var Params        : TDWParams;
                                 EventType         : TSendEvent = sePOST;
                                 JsonMode          : TJsonMode  = jmDataware;
                                 ServerEventName   : String     = '';
                                 Assyncexec        : Boolean    = False;
                                 CallBack          : TCallBack  = Nil) : String Of Object;
 TOnGetToken        = Procedure (Welcomemsg,
                                 AccessTag         : String;
                                 DWParams          : TDWParams;
                                 Var TokenID,
                                 DataBuff          : String;
                                 Var Accept        : Boolean) Of Object;
 TOnTokenSession    = Procedure (Var TokenID       : String;
                                 Var Accept        : Boolean) Of Object;

Type
 TServerMethodClass = Class(TComponent)
End;

Type
 TIdHTTPAccess = class(TIdHTTP)
End;

Type
 TProxyOptions = Class(TPersistent)
 Private
  vServer,                  //Servidor Proxy na Rede
  vLogin,                   //Login do Servidor Proxy
  vPassword     : String;   //Senha do Servidor Proxy
  vPort         : Integer;  //Porta do Servidor Proxy
 Public
  Constructor Create;
  Procedure   Assign(Source : TPersistent); Override;
 Published
  Property Server        : String  Read vServer   Write vServer;   //Servidor Proxy na Rede
  Property Port          : Integer Read vPort     Write vPort;     //Porta do Servidor Proxy
  Property Login         : String  Read vLogin    Write vLogin;    //Login do Servidor
  Property Password      : String  Read vPassword Write vPassword; //Senha do Servidor
End;

Type
 TTokenValue = Class
 Private
  vInitRequest        : TDateTime;
  vServerInfoRequest,
  vClientInfoRequest,
  vTokenHash,
  vDataBuff,
  vMD5                : String;
  vCripto             : TCripto;
  Procedure   SetTokenHash      (Token : String);
 Public
  Constructor Create;
  Destructor  Destroy;Override;
  Class Function    GetMD5      (Const Value : String)     : String;
  Class Function    ISO8601FromDateTime(Value : TDateTime) : String;
  Class Function    DateTimeFromISO8601(Value : String)    : TDateTime;
  Function    ToToken           : String;
  Procedure   FromToken(Value   : String);
  Property    TokenTime         : TDateTime Read vInitRequest;
  Property    ServerInfoRequest : String    Read vServerInfoRequest Write vServerInfoRequest;
  Property    ClientInfoRequest : String    Read vClientInfoRequest Write vClientInfoRequest;
  Property    MD5               : String    Read vMD5;
  Property    DataBuff          : String    Read vDataBuff          Write vDataBuff;
  Property    TokenHash         : String    Read vTokenHash         Write SetTokenHash;
End;

Type
 TServerTokenOptions = Class(TPersistent)
 Private
  vActive     : Boolean;
  vServerRequest,
  vTokenHash  : String;
  vLifeCycle  : Integer;
  vTokenValue : TTokenValue;
  Procedure   SetTokenHash(Token  : String);
 Public
  Constructor Create;
  Destructor  Destroy;Override;
  Procedure   Assign      (Source : TPersistent); Override;
 Published
  Property   Active               : Boolean Read vActive        Write vActive;
  Property   ServerRequest        : String  Read vServerRequest Write vServerRequest;
  Property   TokenHash            : String  Read vTokenHash     Write SetTokenHash;
  Property   LifeCycle            : Integer Read vLifeCycle     Write vLifeCycle;
End;

Type
 TClientTokenOptions = Class(TPersistent)
 Private
  vActive     : Boolean;
  vDataBuff,
  vClientRequest,
  vTokenHash,
  vTokenID    : String;
  vTokenValue : TTokenValue;
  Procedure   SetTokenHash(Token  : String);
 Public
  Constructor Create;
  Destructor  Destroy;Override;
  Procedure   Assign      (Source : TPersistent); Override;
  Procedure   FromToken   (Value  : String);
 Published
  Property   Active               : Boolean Read vActive        Write vActive;
  Property   ClientRequest        : String  Read vClientRequest;
  Property   TokenHash            : String  Read vTokenHash     Write SetTokenHash;
  Property   TokenID              : String  Read vTokenID       Write vTokenID;
  Property   DataBuff             : String  Read vDataBuff      Write vDataBuff;
End;

Type
 TRESTDWServiceNotification = Class(TDWComponent)
 Protected
 Private
  vAccessTag            : String;
  vGarbageTime,
  vQueueNotifications   : Integer;
  vNotifyWelcomeMessage : TNotifyWelcomeMessage;
  Procedure  SetAccessTag(Value : String);
  Function   GetAccessTag       : String;
 Public
  Function GetNotifications(LastNotification : String) : String;
  Constructor Create       (AOwner           : TComponent);Override; //Cria o Componente
  Destructor  Destroy;Override; //Destroy a Classe
 Published
  Property GarbageTime          : Integer                Read vGarbageTime           Write vGarbageTime;
  Property QueueNotifications   : Integer                Read vQueueNotifications    Write vQueueNotifications;
  Property AccessTag            : String                 Read vAccessTag             Write vAccessTag;
  Property OnWelcomeMessage     : TNotifyWelcomeMessage  Read vNotifyWelcomeMessage  Write vNotifyWelcomeMessage;
End;

Type
 TRESTServicePooler = Class(TDWComponent)
 Protected
  Procedure aCommandGet  (AContext      : TIdContext;
                          ARequestInfo  : TIdHTTPRequestInfo;
                          AResponseInfo : TIdHTTPResponseInfo);
  Procedure aCommandOther(AContext      : TIdContext;
                          ARequestInfo  : TIdHTTPRequestInfo;
                          AResponseInfo : TIdHTTPResponseInfo);
  procedure Notification(AComponent: TComponent; Operation: TOperation); override;
 Private
  {$IFDEF FPC}
   vCriticalSection   : TRTLCriticalSection;
   vDatabaseCharSet   : TDatabaseCharSet;
  {$ELSE}
  {$IF Defined(HAS_FMX)}
   {$IFDEF WINDOWS}
    vDWISAPIRunner    : TDWISAPIRunner;
    vDWCGIRunner      : TDWCGIRunner;
   {$ENDIF}
  {$ELSE}
   vDWISAPIRunner     : TDWISAPIRunner;
   vDWCGIRunner       : TDWCGIRunner;
  {$IFEND}
  {$ENDIF}
  vOnGetToken             : TOnGetToken;
  vOnTokenSessionValidate : TOnTokenSession;
  vBeforeUseCriptKey      : TBeforeUseCriptKey;
  vCORSCustomHeaders,
  vDefaultPage            : TStringList;
  vMultiCORE,
  vForceWelcomeAccess,
  vCORS,
  vActive          : Boolean;
  vProxyOptions    : TProxyOptions;
  vTokenOptions    : TServerTokenOptions;
  HTTPServer       : TIdHTTPServer;
  vServiceTimeout,
  vServicePort     : Integer;
  vCripto          : TCripto;
  vServerMethod    : TComponentClass;
  vServerParams    : TServerParams;
  vLastRequest     : TLastRequest;
  vLastResponse    : TLastResponse;
  lHandler         : TIdServerIOHandlerSSLOpenSSL;
  aSSLMethod       : TIdSSLVersion;
  aSSLVersions     : TIdSSLVersions;
  vASSLRootCertFile,
  vServerContext,
  ASSLPrivateKeyFile,
  ASSLPrivateKeyPassword,
  FRootPath,
  ASSLCertFile        : String;
  VEncondig           : TEncodeSelect;              //Enconding se usar CORS usar UTF8 - Alexandre Abade
  vSSLVerifyMode      : TIdSSLVerifyModeSet;
  vSSLVerifyDepth     : Integer;
  vRESTServiceNotification : TRESTDWServiceNotification;
  vOnCreate           : TOnCreate;
  Procedure SetCORSCustomHeader (Value : TStringList);
  Procedure SetDefaultPage (Value : TStringList);
  Function  SSLVerifyPeer (Certificate : TIdX509; AOk : Boolean; ADepth, AError : Integer) : Boolean;
  Procedure GetSSLPassWord (Var Password              : {$IFNDEF FPC}{$IF (CompilerVersion = 23) OR (CompilerVersion = 24) OR (DEFINED(OLDINDY))}
                                                                                     AnsiString
                                                                                    {$ELSE}
                                                                                     String
                                                                                    {$IFEND}
                                                                                    {$ELSE}
                                                                                     String
                                                                                    {$ENDIF});
  Procedure SetActive      (Value                     : Boolean);
  Function  GetSecure : Boolean;
  Procedure SetServerMethod(Value                     : TComponentClass);
  Procedure Loaded; Override;
  Procedure GetTableNames            (ServerMethodsClass      : TComponent;
                                      Var Pooler              : String;
                                      Var DWParams            : TDWParams;
                                      ConnectionDefs          : TConnectionDefs;
                                      hEncodeStrings          : Boolean;
                                      AccessTag               : String);
  Procedure GetFieldNames            (ServerMethodsClass      : TComponent;
                                      Var Pooler              : String;
                                      Var DWParams            : TDWParams;
                                      ConnectionDefs          : TConnectionDefs;
                                      hEncodeStrings          : Boolean;
                                      AccessTag               : String);
  Procedure GetKeyFieldNames         (ServerMethodsClass      : TComponent;
                                      Var Pooler              : String;
                                      Var DWParams            : TDWParams;
                                      ConnectionDefs          : TConnectionDefs;
                                      hEncodeStrings          : Boolean;
                                      AccessTag               : String);
  Procedure GetPoolerList            (ServerMethodsClass      : TComponent;
                                      Var PoolerList          : String;
                                      AccessTag               : String);
  Function  ServiceMethods           (BaseObject              : TComponent;
                                      AContext                : TIdContext;
                                      UrlMethod               : String;
                                      Var urlContext          : String;
                                      Var DWParams            : TDWParams;
                                      Var JSONStr             : String;
                                      Var JsonMode            : TJsonMode;
                                      Var ErrorCode           : Integer;
                                      Var ContentType         : String;
                                      Var ServerContextCall   : Boolean;
                                      Var ServerContextStream : TMemoryStream;
                                      ConnectionDefs          : TConnectionDefs;
                                      hEncodeStrings          : Boolean;
                                      AccessTag               : String;
                                      WelcomeAccept           : Boolean;
                                      Const RequestType       : TRequestType;
                                      mark                    : String;
                                      RequestHeader           : TStringList;
                                      BinaryEvent             : Boolean;
                                      Metadata                : Boolean;
                                      BinaryCompatibleMode    : Boolean) : Boolean;
  Procedure EchoPooler               (ServerMethodsClass      : TComponent;
                                      AContext                : TIdContext;
                                      Var Pooler, MyIP        : String;
                                      AccessTag               : String;
                                      Var InvalidTag          : Boolean);
  Procedure ExecuteCommandPureJSON   (ServerMethodsClass      : TComponent;
                                      Var Pooler              : String;
                                      Var DWParams            : TDWParams;
                                      ConnectionDefs          : TConnectionDefs;
                                      hEncodeStrings          : Boolean;
                                      AccessTag               : String;
                                      BinaryEvent             : Boolean;
                                      Metadata                : Boolean;
                                      BinaryCompatibleMode    : Boolean);
  Procedure ExecuteCommandJSON       (ServerMethodsClass      : TComponent;
                                      Var Pooler              : String;
                                      Var DWParams            : TDWParams;
                                      ConnectionDefs          : TConnectionDefs;
                                      hEncodeStrings          : Boolean;
                                      AccessTag               : String;
                                      BinaryEvent             : Boolean;
                                      Metadata                : Boolean;
                                      BinaryCompatibleMode    : Boolean);
  Procedure InsertMySQLReturnID      (ServerMethodsClass      : TComponent;
                                      Var Pooler              : String;
                                      Var DWParams            : TDWParams;
                                      ConnectionDefs          : TConnectionDefs;
                                      hEncodeStrings          : Boolean;
                                      AccessTag               : String);
  Procedure ApplyUpdatesJSON         (ServerMethodsClass      : TComponent;
                                      Var Pooler              : String;
                                      Var DWParams            : TDWParams;
                                      ConnectionDefs          : TConnectionDefs;
                                      hEncodeStrings          : Boolean;
                                      AccessTag               : String);
  Procedure OpenDatasets             (ServerMethodsClass      : TComponent;
                                      Var Pooler              : String;
                                      Var DWParams            : TDWParams;
                                      ConnectionDefs          : TConnectionDefs;
                                      hEncodeStrings          : Boolean;
                                      AccessTag               : String;
                                      BinaryRequest           : Boolean);
  Procedure ApplyUpdates_MassiveCache(ServerMethodsClass      : TComponent;
                                      Var Pooler              : String;
                                      Var DWParams            : TDWParams;
                                      ConnectionDefs          : TConnectionDefs;
                                      hEncodeStrings          : Boolean;
                                      AccessTag               : String);
  Procedure ProcessMassiveSQLCache   (ServerMethodsClass      : TComponent;
                                      Var Pooler              : String;
                                      Var DWParams            : TDWParams;
                                      ConnectionDefs          : TConnectionDefs;
                                      hEncodeStrings          : Boolean;
                                      AccessTag               : String);
  Procedure GetEvents                (ServerMethodsClass      : TComponent;
                                      Var Pooler,
                                      urlContext              : String;
                                      Var DWParams            : TDWParams);
  Function ReturnEvent               (ServerMethodsClass      : TComponent;
                                      Var Pooler,
                                      vResult,
                                      urlContext              : String;
                                      Var DWParams            : TDWParams;
                                      Var JsonMode            : TJsonMode;
                                      Var ErrorCode           : Integer;
                                      Var ContentType,
                                      AccessTag               : String;
                                      Const RequestType       : TRequestType;
                                      Var   RequestHeader     : TStringList) : Boolean;
  Procedure GetServerEventsList      (ServerMethodsClass      : TComponent;
                                      Var ServerEventsList    : String;
                                      AccessTag               : String);
  Function  ReturnContext            (ServerMethodsClass      : TComponent;
                                      Var Pooler, vResult,
                                      urlContext,
                                      ContentType             : String;
                                      Var ServerContextStream : TMemoryStream;
                                      Var Error               : Boolean;
                                      Var   DWParams          : TDWParams;
                                      Const RequestType       : TRequestType;
                                      mark                    : String;
                                      RequestHeader           : TStringList;
                                      Var ErrorCode           : Integer) : Boolean;

  {$IFDEF FPC}
  {$ELSE}
  {$IF Defined(HAS_FMX)}
   {$IFDEF WINDOWS}
    Procedure SetISAPIRunner(Value : TDWISAPIRunner);
    Procedure SetCGIRunner  (Value : TDWCGIRunner);
   {$ENDIF}
  {$ELSE}
   Procedure SetISAPIRunner(Value : TDWISAPIRunner);
   Procedure SetCGIRunner  (Value : TDWCGIRunner);
  {$IFEND}
  {$ENDIF}
  procedure SetRESTServiceNotification(Value    : TRESTDWServiceNotification);
  Procedure CustomOnConnect           (AContext : TIdContext);
  procedure IdHTTPServerQuerySSLPort(APort: Word; var VUseSSL: Boolean);
 Public
  Constructor Create       (AOwner : TComponent);Override; //Cria o Componente
  Destructor  Destroy; Override;                      //Destroy a Classe
 Published
  Property Active                  : Boolean                    Read vActive                  Write SetActive;
  Property CORS                    : Boolean                    Read vCORS                    Write vCORS;
  Property CORS_CustomHeaders      : TStringList                Read vCORSCustomHeaders       Write SetCORSCustomHeader;
  Property DefaultPage             : TStringList                Read vDefaultPage             Write SetDefaultPage;
  Property Secure                  : Boolean                    Read GetSecure;
  Property RequestTimeout          : Integer                    Read vServiceTimeout          Write vServiceTimeout;
  Property ServicePort             : Integer                    Read vServicePort             Write vServicePort;  //A Porta do Servi�o do DataSet
  Property ProxyOptions            : TProxyOptions              Read vProxyOptions            Write vProxyOptions; //Se tem Proxy diz quais as op��es
  Property TokenOptions            : TServerTokenOptions        Read vTokenOptions            Write vTokenOptions;
  Property ServerParams            : TServerParams              Read vServerParams            Write vServerParams;
  Property ServerMethodClass       : TComponentClass            Read vServerMethod            Write SetServerMethod;
  Property SSLPrivateKeyFile       : String                     Read aSSLPrivateKeyFile       Write aSSLPrivateKeyFile;
  Property SSLPrivateKeyPassword   : String                     Read aSSLPrivateKeyPassword   Write aSSLPrivateKeyPassword;
  Property SSLCertFile             : String                     Read aSSLCertFile             Write aSSLCertFile;
  Property SSLMethod               : TIdSSLVersion              Read aSSLMethod               Write aSSLMethod;
  Property SSLVersions             : TIdSSLVersions             Read aSSLVersions             Write aSSLVersions;
  Property OnLastRequest           : TLastRequest               Read vLastRequest             Write vLastRequest;
  Property OnLastResponse          : TLastResponse              Read vLastResponse            Write vLastResponse;
  Property Encoding                : TEncodeSelect              Read VEncondig                Write VEncondig;          //Encoding da string
  Property ServerContext           : String                     Read vServerContext           Write vServerContext;
  Property RootPath                : String                     Read FRootPath                Write FRootPath;
  Property SSLRootCertFile         : String                     Read vaSSLRootCertFile        Write vaSSLRootCertFile;
  property SSLVerifyMode           : TIdSSLVerifyModeSet        Read vSSLVerifyMode           Write vSSLVerifyMode;
  property SSLVerifyDepth          : Integer                    Read vSSLVerifyDepth          Write vSSLVerifyDepth;
  Property ForceWelcomeAccess      : Boolean                    Read vForceWelcomeAccess      Write vForceWelcomeAccess;
  Property RESTServiceNotification : TRESTDWServiceNotification Read vRESTServiceNotification Write SetRESTServiceNotification;
  Property OnBeforeUseCriptKey     : TBeforeUseCriptKey         Read vBeforeUseCriptKey       Write vBeforeUseCriptKey;
  Property CriptOptions            : TCripto                    Read vCripto                  Write vCripto;
  Property MultiCORE               : Boolean                    Read vMultiCORE               Write vMultiCORE;
  Property OnGetToken              : TOnGetToken                Read vOnGetToken              Write vOnGetToken;
  Property OnTokenSessionValidate  : TOnTokenSession            Read vOnTokenSessionValidate  Write vOnTokenSessionValidate;
  {$IFDEF FPC}
  Property DatabaseCharSet         : TDatabaseCharSet           Read vDatabaseCharSet         Write vDatabaseCharSet;
  {$ENDIF}
  Property OnCreate                : TOnCreate                  Read vOnCreate                Write vOnCreate;
  {$IFDEF FPC}
  {$ELSE}
  {$IF Defined(HAS_FMX)}
   {$IFDEF WINDOWS}
    Property ISAPIRunner             : TDWISAPIRunner             Read vDWISAPIRunner           Write SetISAPIRunner;
    Property CGIRunner               : TDWCGIRunner               Read vDWCGIRunner             Write SetCGIRunner;
   {$ENDIF}
  {$ELSE}
  Property ISAPIRunner             : TDWISAPIRunner             Read vDWISAPIRunner           Write SetISAPIRunner;
  Property CGIRunner               : TDWCGIRunner               Read vDWCGIRunner             Write SetCGIRunner;
  {$IFEND}
  {$ENDIF}
End;

Type
 TRESTServiceCGI = Class(TDWComponent)
 Private
  vDefaultPage            : TStringList;
  vCORS,
  vForceWelcomeAccess     : Boolean;
  vBeforeUseCriptKey      : TBeforeUseCriptKey;
  vTokenOptions           : TServerTokenOptions;
  vOnGetToken             : TOnGetToken;
  vOnTokenSessionValidate : TOnTokenSession;
  vServerContext,
  FRootPath               : String;
  vCripto                 : TCripto;
  vServerBaseMethod,
  vServerMethod       : TComponentClass;
  vServerParams       : TServerParams;
  vLastRequest        : TLastRequest;
  vLastResponse       : TLastResponse;
  vOnCreate           : TOnCreate;
  VEncondig           : TEncodeSelect;              //Enconding se usar CORS usar UTF8 - Alexandre Abade
  vRESTServiceNotification : TRESTDWServiceNotification;
  vCORSCustomHeaders  : TStringList;
  {$IFDEF FPC}
  vDatabaseCharSet    : TDatabaseCharSet;
  {$ENDIF}
  Procedure Loaded; Override;
  Procedure SetServerMethod(Value                     : TComponentClass);
  Procedure GetPoolerList(ServerMethodsClass          : TComponent;
                          Var PoolerList              : String;
                          AccessTag                   : String);
  Function  ServiceMethods(BaseObject                 : TComponent;
                           AContext,
                           UrlMethod,
                           urlContext                 : String;
                           Var DWParams               : TDWParams;
                           Var JSONStr                : String;
                           Var JsonMode               : TJsonMode;
                           Var ErrorCode              : Integer;
                           Var ContentType            : String;
                           Var ServerContextCall      : Boolean;
                           Var ServerContextStream    : TMemoryStream;
                           ConnectionDefs             : TConnectionDefs;
                           hEncodeStrings             : Boolean;
                           AccessTag                  : String;
                           WelcomeAccept              : Boolean;
                           Const RequestType          : TRequestType;
                           mark                       : String;
                           Var   RequestHeader        : TStringList;
                           BinaryEvent                : Boolean;
                           Metadata                   : Boolean;
                           BinaryCompatibleMode       : Boolean) : Boolean;
  Procedure EchoPooler    (ServerMethodsClass         : TComponent;
                           AContext                   : String;
                           Var Pooler, MyIP           : String;
                           AccessTag                  : String;
                           Var InvalidTag             : Boolean);
  Procedure GetFieldNames         (ServerMethodsClass   : TComponent;
                                   Var Pooler           : String;
                                   Var DWParams         : TDWParams;
                                   ConnectionDefs       : TConnectionDefs;
                                   hEncodeStrings       : Boolean;
                                   AccessTag            : String);
  Procedure GetKeyFieldNames      (ServerMethodsClass   : TComponent;
                                   Var Pooler           : String;
                                   Var DWParams         : TDWParams;
                                   ConnectionDefs       : TConnectionDefs;
                                   hEncodeStrings       : Boolean;
                                   AccessTag            : String);
  Procedure GetTableNames         (ServerMethodsClass   : TComponent;
                                   Var Pooler           : String;
                                   Var DWParams         : TDWParams;
                                   ConnectionDefs       : TConnectionDefs;
                                   hEncodeStrings       : Boolean;
                                   AccessTag            : String);
  Procedure ExecuteCommandPureJSON(ServerMethodsClass   : TComponent;
                                   Var Pooler           : String;
                                   Var DWParams         : TDWParams;
                                   ConnectionDefs       : TConnectionDefs;
                                   hEncodeStrings       : Boolean;
                                   AccessTag            : String;
                                   BinaryEvent          : Boolean;
                                   Metadata             : Boolean;
                                   BinaryCompatibleMode : Boolean);
  Procedure ExecuteCommandJSON(ServerMethodsClass       : TComponent;
                               Var Pooler               : String;
                               Var DWParams             : TDWParams;
                               ConnectionDefs           : TConnectionDefs;
                                   hEncodeStrings       : Boolean;
                                   AccessTag            : String;
                                   BinaryEvent          : Boolean;
                                   Metadata             : Boolean;
                                   BinaryCompatibleMode : Boolean);
  Procedure InsertMySQLReturnID  (ServerMethodsClass    : TComponent;
                                  Var Pooler            : String;
                                  Var DWParams          : TDWParams;
                                  ConnectionDefs        : TConnectionDefs;
                                     hEncodeStrings     : Boolean;
                                     AccessTag          : String);
  Procedure ApplyUpdatesJSON     (ServerMethodsClass    : TComponent;
                                  Var Pooler            : String;
                                  Var DWParams          : TDWParams;
                                  ConnectionDefs        : TConnectionDefs;
                                     hEncodeStrings     : Boolean;
                                     AccessTag          : String);
  Procedure OpenDatasets       (ServerMethodsClass      : TComponent;
                                Var Pooler              : String;
                                Var DWParams            : TDWParams;
                                ConnectionDefs          : TConnectionDefs;
                                   hEncodeStrings       : Boolean;
                                   AccessTag            : String;
                                   BinaryRequest        : Boolean);
  Procedure ApplyUpdates_MassiveCache(ServerMethodsClass : TComponent;
                                      Var Pooler         : String;
                                      Var DWParams       : TDWParams;
                                      ConnectionDefs     : TConnectionDefs;
                                      hEncodeStrings     : Boolean;
                                      AccessTag          : String);
  Procedure ProcessMassiveSQLCache   (ServerMethodsClass      : TComponent;
                                      Var Pooler              : String;
                                      Var DWParams            : TDWParams;
                                      ConnectionDefs          : TConnectionDefs;
                                      hEncodeStrings          : Boolean;
                                      AccessTag               : String);
  Procedure GetEvents                (ServerMethodsClass : TComponent;
                                      Var Pooler,
                                      urlContext         : String;
                                      Var DWParams       : TDWParams);
  Function ReturnEvent               (ServerMethodsClass : TComponent;
                                      Var Pooler,
                                      vResult,
                                      urlContext         : String;
                                      Var DWParams       : TDWParams;
                                      Var JsonMode       : TJsonMode;
                                      Var ErrorCode      : Integer;
                                      Var ContentType,
                                      AccessTag          : String;
                                      Const RequestType  : TRequestType;
                                      RequestHeader      : TStringList): Boolean;
  Procedure GetServerEventsList      (ServerMethodsClass   : TComponent;
                                      Var ServerEventsList : String;
                                      AccessTag            : String);
  Function ReturnContext             (ServerMethodsClass      : TComponent;
                                      Var Pooler, vResult,
                                      urlContext,
                                      ContentType             : String;
                                      Var ServerContextStream : TMemoryStream;
                                      Var Error               : Boolean;
                                      Var   DWParams          : TDWParams;
                                      Const RequestType       : TRequestType;
                                      mark                    : String;
                                      RequestHeader           : TStringList;
                                      Var ErrorCode           : Integer): Boolean;
   procedure SetRESTServiceNotification(Value: TRESTDWServiceNotification);
   Procedure SetDefaultPage (Value : TStringList);
   Procedure SetCORSCustomHeader (Value : TStringList);
 Protected
   procedure Notification(AComponent: TComponent; Operation: TOperation); override;
 Public
  {$IFDEF FPC}
   Procedure Command(ARequest: TRequest;    AResponse: TResponse;   Var Handled: Boolean);
  {$ELSE}
   Procedure Command(ARequest: TWebRequest; AResponse: TWebResponse; var Handled: Boolean);
  {$ENDIF}
  Constructor Create(AOwner        : TComponent);Override; //Cria o Componente
  Destructor  Destroy;Override;                      //Destroy a Classe
 Published
  Property CORS                    : Boolean                    Read vCORS                    Write vCORS;
  Property CORS_CustomHeaders      : TStringList                Read vCORSCustomHeaders       Write SetCORSCustomHeader;
  Property DefaultPage             : TStringList                Read vDefaultPage             Write SetDefaultPage;
  Property ServerParams            : TServerParams              Read vServerParams            Write vServerParams;
  Property ServerMethodClass       : TComponentClass            Read vServerMethod            Write SetServerMethod;
  Property OnLastRequest           : TLastRequest               Read vLastRequest             Write vLastRequest;
  Property OnLastResponse          : TLastResponse              Read vLastResponse            Write vLastResponse;
  Property OnCreate                : TOnCreate                  Read vOnCreate                Write vOnCreate;
  Property Encoding                : TEncodeSelect              Read VEncondig                Write VEncondig;          //Encoding da string
  Property ForceWelcomeAccess      : Boolean                    Read vForceWelcomeAccess      Write vForceWelcomeAccess;
  Property ServerContext           : String                     Read vServerContext           Write vServerContext;
  Property RESTServiceNotification : TRESTDWServiceNotification Read vRESTServiceNotification Write SetRESTServiceNotification;
  Property RootPath                : String                     Read FRootPath                Write FRootPath;
  Property OnBeforeUseCriptKey     : TBeforeUseCriptKey         Read vBeforeUseCriptKey       Write vBeforeUseCriptKey;
  Property CriptOptions            : TCripto                    Read vCripto                  Write vCripto;
  Property TokenOptions            : TServerTokenOptions        Read vTokenOptions            Write vTokenOptions;
  Property OnGetToken              : TOnGetToken                Read vOnGetToken              Write vOnGetToken;
  Property OnTokenSessionValidate  : TOnTokenSession            Read vOnTokenSessionValidate  Write vOnTokenSessionValidate;
  {$IFDEF FPC}
  Property DatabaseCharSet         : TDatabaseCharSet           Read vDatabaseCharSet         Write vDatabaseCharSet;
  {$ENDIF}
End;

Type
 TRESTDWConnectionServerCP = Class(TCollectionItem)
 Private
  vTransparentProxy     : TIdProxyConnectionInfo;
  vAuthentication,
  vEncodeStrings,
  vCompression,
  vActive               : Boolean;
  vTimeOut,
  vPoolerPort           : Integer;
  vServerEventName,
  vListName,
  vAccessTag,
  vWelcomeMessage,
  vRestURL,
  vRestWebService,
  vPassword,
  vLogin                : String;
  vEncoding             : TEncodeSelect;
  {$IFDEF FPC}
  vDatabaseCharSet      : TDatabaseCharSet;
  {$ENDIF}
  vTypeRequest          : TTypeRequest;
 Public
  Function    GetDisplayName             : String;      Override;
  Procedure   SetDisplayName(Const Value : String);     Override;
  Function    GetPoolerList : TStringList;
  Constructor Create        (aCollection : TCollection);Override;
  Destructor  Destroy;Override;//Destroy a Classe
 Published
  Property Active               : Boolean                  Read vActive               Write vActive;            //Seta o Estado da Conex�o
  Property Compression          : Boolean                  Read vCompression          Write vCompression;       //Compress�o de Dados
  Property UserName             : String                   Read vLogin                Write vLogin;             //Login do Usu�rio caso haja autentica��o
  Property Password             : String                   Read vPassword             Write vPassword;          //Senha do Usu�rio caso haja autentica��o
  Property Authentication       : Boolean                  Read vAuthentication       Write vAuthentication      Default True;
  Property ProxyOptions         : TIdProxyConnectionInfo   Read vTransparentProxy     Write vTransparentProxy;
  Property Host                 : String                   Read vRestWebService       Write vRestWebService;    //Host do WebService REST
  Property UrlPath              : String                   Read vRestURL              Write vRestURL;           //URL do WebService REST
  Property Port                 : Integer                  Read vPoolerPort           Write vPoolerPort;        //A Porta do Pooler do DataSet
  Property RequestTimeOut       : Integer                  Read vTimeOut              Write vTimeOut;           //Timeout da Requisi��o
  Property hEncodeStrings       : Boolean                  Read vEncodeStrings        Write vEncodeStrings;
  Property Encoding             : TEncodeSelect            Read vEncoding             Write vEncoding;          //Encoding da string
  Property WelcomeMessage       : String                   Read vWelcomeMessage       Write vWelcomeMessage;
  {$IFDEF FPC}
  Property DatabaseCharSet      : TDatabaseCharSet         Read vDatabaseCharSet      Write vDatabaseCharSet;
  {$ENDIF}
  Property Name                 : String                   Read vListName             Write vListName;
  Property AccessTag            : String                   Read vAccessTag            Write vAccessTag;
  Property TypeRequest          : TTypeRequest             Read vTypeRequest          Write vTypeRequest       Default trHttp;
  Property ServerEventName      : String                   Read vServerEventName      Write vServerEventName;
End;

Type
 TOnFailOverExecute       = Procedure (ConnectionServer   : TRESTDWConnectionServerCP) Of Object;
 TOnFailOverError         = Procedure (ConnectionServer   : TRESTDWConnectionServerCP;
                                       MessageError       : String)                  Of Object;

Type
 TFailOverConnections = Class(TDWOwnedCollection)
 Private
  Function    GetOwner: TPersistent; override;
 Private
  fOwner      : TPersistent;
  Function    GetRec     (Index       : Integer) : TRESTDWConnectionServerCP;  Overload;
  Procedure   PutRec     (Index       : Integer;
                          Item        : TRESTDWConnectionServerCP);            Overload;
  Function    GetRecName(Index        : String)  : TRESTDWConnectionServerCP;  Overload;
  Procedure   PutRecName(Index        : String;
                         Item         : TRESTDWConnectionServerCP);            Overload;
  Procedure   ClearList;
 Public
  Constructor Create     (AOwner      : TPersistent;
                          aItemClass  : TCollectionItemClass);
  Destructor  Destroy; Override;
  Function    Add                     : TCollectionItem;
  Procedure   Delete     (Index       : Integer);  Overload;
  Procedure   Delete     (Index       : String);   Overload;
  Property    Items      [Index       : Integer] : TRESTDWConnectionServerCP Read GetRec     Write PutRec; Default;
  Property    ItemsByName[Index       : String ] : TRESTDWConnectionServerCP Read GetRecName Write PutRecName;
End;

Type
 TRESTClientPooler = Class(TDWComponent) //Novo Componente de Acesso a Requisi��es REST para o RESTDataware
 Protected
  //Vari�veis, Procedures e  Fun��es Protegidas
  HttpRequest       : TIdHTTP;
  LHandler          : TIdSSLIOHandlerSocketOpenSSL;
  vCripto           : TCripto;
  vTokenOptions     : TClientTokenOptions;
  Procedure SetParams      (Var aHttpRequest  : TIdHTTP;
                            Authentication    : Boolean;
                            UserName,
                            Password          : String;
                            TransparentProxy  : TIdProxyConnectionInfo;
                            RequestTimeout    : Integer);
  Procedure SetOnWork      (Value             : TOnWork);
  Procedure SetOnWorkBegin (Value             : TOnWorkBegin);
  Procedure SetOnWorkEnd   (Value             : TOnWorkEnd);
  Procedure SetOnStatus    (Value             : TOnStatus);
  Function  GetAllowCookies                   : Boolean;
  Procedure SetAllowCookies(Value             : Boolean);
  Function  GetHandleRedirects                : Boolean;
  Procedure SetHandleRedirects(Value          : Boolean);
 Private
  //Vari�veis, Procedures e Fun��es Privadas
  vOnWork              : TOnWork;
  vOnWorkBegin         : TOnWorkBegin;
  vOnWorkEnd           : TOnWorkEnd;
  vOnStatus            : TOnStatus;
  vOnFailOverExecute   : TOnFailOverExecute;
  vOnFailOverError     : TOnFailOverError;
  vOnBeforeExecute     : TOnBeforeExecute;
  vTypeRequest         : TTypeRequest;
  vRSCharset           : TEncodeSelect;
  vUserAgent,
  vAccessTag,
  vWelcomeMessage,
  vUrlPath,
  vUserName,
  vPassword,
  vHost                : String;
  vPort                : Integer;
  vBinaryRequest,
  vFailOver,
  vFailOverReplaceDefaults,
  vEncodeStrings,
  vDatacompress,
  vThreadRequest,
  vAuthentication,
  vThreadExecuting     : Boolean;
  vTransparentProxy    : TIdProxyConnectionInfo;
  vRequestTimeOut      : Integer;
  {$IFDEF FPC}
  vDatabaseCharSet     : TDatabaseCharSet;
  {$ENDIF}
  vFailOverConnections : TFailOverConnections;
  Procedure SetUserName(Value : String);
  Procedure SetPassword(Value : String);
  Procedure SetUrlPath (Value : String);
 Public
  //M�todos, Propriedades, Vari�veis, Procedures e Fun��es Publicas
  Procedure   SetAccessTag(Value        : String);
  Function    GetAccessTag              : String;
  Function    SendEvent(EventData       : String)          : String;Overload;
  Function    SendEvent(EventData       : String;
                        Var Params      : TDWParams;
                        EventType       : TSendEvent = sePOST;
                        JsonMode        : TJsonMode  = jmDataware;
                        ServerEventName : String     = '';
                        Assyncexec      : Boolean    = False;
                        CallBack        : TCallBack  = Nil) : String;Overload;
  Constructor Create   (AOwner          : TComponent);Override;
  Destructor  Destroy;Override;
 Published
  //M�todos e Propriedades
  Property DataCompression         : Boolean                Read vDatacompress            Write vDatacompress;
  Property UrlPath                 : String                 Read vUrlPath                 Write SetUrlPath;
  Property Encoding                : TEncodeSelect          Read vRSCharset               Write vRSCharset;
  Property hEncodeStrings          : Boolean                Read vEncodeStrings           Write vEncodeStrings;
  Property TypeRequest             : TTypeRequest           Read vTypeRequest             Write vTypeRequest         Default trHttp;
  Property Host                    : String                 Read vHost                    Write vHost;
  Property Port                    : Integer                Read vPort                    Write vPort                Default 8082;
  Property UserName                : String                 Read vUserName                Write SetUserName;
  Property Password                : String                 Read vPassword                Write SetPassword;
  Property Authentication          : Boolean                Read vAuthentication          Write vAuthentication      Default True;
  Property ProxyOptions            : TIdProxyConnectionInfo Read vTransparentProxy        Write vTransparentProxy;
  Property RequestTimeOut          : Integer                Read vRequestTimeOut          Write vRequestTimeOut;
  Property ThreadRequest           : Boolean                Read vThreadRequest           Write vThreadRequest;
  Property AllowCookies            : Boolean                Read GetAllowCookies          Write SetAllowCookies;
  Property HandleRedirects         : Boolean                Read GetHandleRedirects       Write SetHandleRedirects;
  Property WelcomeMessage          : String                 Read vWelcomeMessage          Write vWelcomeMessage;
  Property AccessTag               : String                 Read vAccessTag               Write vAccessTag;
  Property OnWork                  : TOnWork                Read vOnWork                  Write SetOnWork;
  Property OnWorkBegin             : TOnWorkBegin           Read vOnWorkBegin             Write SetOnWorkBegin;
  Property OnWorkEnd               : TOnWorkEnd             Read vOnWorkEnd               Write SetOnWorkEnd;
  Property OnStatus                : TOnStatus              Read vOnStatus                Write SetOnStatus;
  Property OnFailOverExecute       : TOnFailOverExecute     Read vOnFailOverExecute       Write vOnFailOverExecute;
  Property OnFailOverError         : TOnFailOverError       Read vOnFailOverError         Write vOnFailOverError;
  Property OnBeforeExecute         : TOnBeforeExecute       Read vOnBeforeExecute         Write vOnBeforeExecute;
  Property FailOver                : Boolean                Read vFailOver                Write vFailOver;
  Property FailOverConnections     : TFailOverConnections   Read vFailOverConnections     Write vFailOverConnections;
  Property FailOverReplaceDefaults : Boolean                Read vFailOverReplaceDefaults Write vFailOverReplaceDefaults;
  Property BinaryRequest           : Boolean                Read vBinaryRequest           Write vBinaryRequest;
  Property CriptOptions            : TCripto                Read vCripto                  Write vCripto;
  Property UserAgent               : String                 Read vUserAgent               Write vUserAgent;
  Property TokenOptions            : TClientTokenOptions    Read vTokenOptions            Write vTokenOptions;
  {$IFDEF FPC}
  Property DatabaseCharSet         : TDatabaseCharSet       Read vDatabaseCharSet         Write vDatabaseCharSet;
  {$ENDIF}
End;

implementation

Uses uDWDatamodule, uRESTDWPoolerDB, SysTypes, uDWJSONTools, uRESTDWServerEvents,
     uRESTDWServerContext, uDWJSONInterface, uDWPoolerMethod;

Procedure DeleteInvalidChar(Var Value : String);
Begin
 If Length(Value) > 0 Then
  If Value[InitStrPos] <> '{' then
   Delete(Value, 1, 1);
 If Length(Value) > 0 Then
  If Value[Length(Value) - FinalStrPos] <> '{' then
   Delete(Value, Length(Value), 1);
End;

Function GetParamsReturn(Params : TDWParams) : String;
Var
 A, I : Integer;
Begin
 A := 0;
 Result := '';
 If Assigned(Params) Then
  Begin
   For I := 0 To Params.Count -1 Do
    Begin
     If TJSONParam(TList(Params).Items[I]^).ObjectDirection in [odOUT, odINOUT] Then
      Begin
       If A = 0 Then
        Result := TJSONParam(TList(Params).Items[I]^).ToJSON
       Else
        Result := Result + ', ' + TJSONParam(TList(Params).Items[I]^).ToJSON;
       Inc(A);
      End;
    End;
  End;
 If Trim(Result) = '' Then
  Result := 'null';
End;

{ TRESTServiceCGI }

{$IFDEF FPC}
procedure TRESTServiceCGI.Command(ARequest: TRequest; AResponse: TResponse;
                                  Var Handled: Boolean);
{$ELSE}
procedure TRESTServiceCGI.Command(ARequest: TWebRequest; AResponse: TWebResponse;
  var Handled: Boolean);
{$ENDIF}
Var
 I, vErrorCode       : Integer;
 JsonMode            : TJsonMode;
 DWParams            : TDWParams;
 vObjectName,
 vOldMethod,
 vBasePath,
 vWelcomeMessage,
 vAccessTag,
 vIPVersion,
 boundary,
 startboundary,
 vReplyString,
 vReplyStringResult,
 vTempCmd,
 Cmd, vmark,
 UrlMethod,
 tmp, JSONStr,
 sFile,
 authDecode,
 sCharSet,
 aurlContext,
 urlContext,
 baseEventUnit,
 ServerEventsName,
 vErrorMessage,
 vContentType,
 ReturnObject        : String;
 vdwConnectionDefs   : TConnectionDefs;
 RequestType         : TRequestType;
 vTempServerMethods  : TObject;
 newdecoder,
 Decoder             : TIdMessageDecoder;
 JSONParam           : TJSONParam;
 JSONValue           : TJSONValue;
 vMetadata,
 vBinaryEvent,
 vBinaryCompatibleMode,
 dwassyncexec,
 vFileExists,
 vServerContextCall,
 vTagReply,
 WelcomeAccept,
 encodestrings,
 compresseddata,
 vdwCriptKey,
 msgEnd              : Boolean;
 mb,
 vContentStringStream,
 ms                  : TStringStream;
 mb2                 : TMemoryStream;
 ServerContextStream : TMemoryStream;
 vParamList,
 vRequestHeader,
 vLog                : TStringList;
 Procedure SaveLog(DebbugValue : String);
 var
  i: integer;
 Begin
  vLog := TStringList.Create;
  vLog.Add(ARequest.ContentFields.Text);
  vLog.Add('**********************');
  vLog.Add('DebbugValue =>> ' + Trim(DebbugValue));
  {$IFNDEF FPC}
   vLog.Add('Cmd = ' + Trim(ARequest.URL));
  {$ELSE}
   vLog.Add('Cmd =>> ' + Trim(ARequest.CommandLine));
  {$ENDIF}
  vLog.Add('PathInfo =>> ' + Trim(ARequest.PathInfo));
  {$IFNDEF FPC}
  vLog.Add('Title = ' + ARequest.Title);
  {$ELSE}
  vLog.Add('HeaderLine =>> ' + ARequest.HeaderLine);
  {$ENDIF}
  vLog.Add('Content =>> ' +  ARequest.Content);
  vLog.Add('Query =>> ' +  ARequest.Query);
  If vServerParams.HasAuthentication Then
   vLog.Add('HasAuthentication =>> true')
  Else
   vLog.Add('HasAuthentication =>> false');
  vLog.Add('Authorization =>> ' +  ARequest.Authorization);
  {$IFNDEF FPC}
  vLog.Add('ContentFields.Count = ' +  IntToStr(ARequest.ContentFields.Count));
  {$ELSE}
  vLog.Add('FieldCount =>> ' +  IntToStr(ARequest.FieldCount));
  for i := 0 to ARequest.FieldCount -1 Do
   vLog.Add(Format('Field[%d] = %s', [I, ARequest.Fields[I]]));
  {$ENDIF}
  vLog.Add('ContentFields =>> ' +  ARequest.ContentFields.Text);
  {$IFNDEF FPC}
  vLog.Add('PathTranslated = ' + ARequest.PathTranslated);
  {$ELSE}
  vLog.Add('LocalPathPrefix =>> ' + ARequest.LocalPathPrefix);
  {$ENDIF}
  vLog.Add('UrlMethod =>> ' + UrlMethod);
  vLog.Add('urlContext =>> ' + urlContext);
  vLog.Add('Method =>> ' + ARequest.Method);
  vLog.Add('File =>> ' + sFile);
  If DWParams <> Nil Then
   vLog.Add('DWParams =>> ' +  DWParams.ToJSON);
  vLog.SaveToFile(ExtractFilePath(ParamSTR(0)) + formatdatetime('ddmmyyyyhhmmss', Now) + 'log.txt');
  vLog.Free;
 End;
 Function ExcludeTag(Value : String) : String;
 Begin
  Result := Value;
  If (UpperCase(Copy (Value, InitStrPos, 3)) = 'GET')    or
     (UpperCase(Copy (Value, InitStrPos, 4)) = 'POST')   or
     (UpperCase(Copy (Value, InitStrPos, 3)) = 'PUT')    or
     (UpperCase(Copy (Value, InitStrPos, 6)) = 'DELETE') or
     (UpperCase(Copy (Value, InitStrPos, 5)) = 'PATCH')  Then
   Begin
    While (Result <> '') And (Result[InitStrPos] <> '/') Do
     Delete(Result, InitStrPos, 1);
   End;
  If Result <> '' Then
   If Result[InitStrPos] = '/' Then
    Delete(Result, InitStrPos, 1);
  Result := Trim(Result);
 End;
 Function GetFileOSDir(Value : String) : String;
 Begin
  Result := vBasePath + Value;
  {$IFDEF MSWINDOWS}
   Result := StringReplace(Result, '/', '\', [rfReplaceAll]);
  {$ENDIF}
 End;
 Function GetLastMethod(Value : String) : String;
 Var
  I : Integer;
 Begin
  Result := '';
  If Value <> '' Then
   Begin
    If Value[Length(Value) - FinalStrPos] <> '/' Then
     Begin
      For I := (Length(Value) - FinalStrPos) Downto InitStrPos Do
       Begin
        If Value[I] <> '/' Then
         Result := Value[I] + Result
        Else
         Break;
       End;
     End;
   End;
 End;
 procedure ReadRawHeaders;
 {$IFDEF FPC}
 Var
  I: Integer;
  {$ENDIF}
 begin
  {$IFDEF FPC}
  If (ARequest.CustomHeaders = Nil) Then
   Exit;
  Try
   If (ARequest.CustomHeaders.Count > 0) Then
    Begin
     vRequestHeader.Add(ARequest.CustomHeaders.Text);
     For I := 0 To ARequest.CustomHeaders.Count -1 Do
      Begin
       tmp := ARequest.CustomHeaders.Names[I];
       If pos('dwwelcomemessage', lowercase(tmp)) > 0 Then
        vWelcomeMessage := DecodeStrings(ARequest.CustomHeaders.Values[tmp]{$IFDEF FPC}, vDatabaseCharSet{$ENDIF})
       Else If pos('BinaryCompatibleMode', lowercase(tmp)) > 0 Then
        vBinaryCompatibleMode := StringToBoolean(ARequest.CustomHeaders.Values[tmp])
       Else If pos('dwaccesstag', lowercase(tmp)) > 0 Then
        vAccessTag := DecodeStrings(ARequest.CustomHeaders.Values[tmp]{$IFDEF FPC}, vDatabaseCharSet{$ENDIF})
       Else If pos('datacompression', lowercase(tmp)) > 0 Then
        compresseddata := StringToBoolean(ARequest.CustomHeaders.Values[tmp])
       Else If pos('dwencodestrings', lowercase(tmp)) > 0 Then
        encodestrings  := StringToBoolean(ARequest.CustomHeaders.Values[tmp])
       Else If pos('dwusecript', lowercase(tmp)) > 0 Then
        vdwCriptKey    := StringToBoolean(ARequest.CustomHeaders.Values[tmp])
       Else If pos('dwassyncexec', lowercase(tmp)) > 0 Then
        dwassyncexec   := StringToBoolean(ARequest.CustomHeaders.Values[tmp])
       Else If pos('binaryrequest', lowercase(tmp)) > 0 Then
        vBinaryEvent   := StringToBoolean(ARequest.CustomHeaders.Values[tmp])
       Else If pos('dwconnectiondefs', lowercase(tmp)) > 0 Then
        Begin
         vdwConnectionDefs   := TConnectionDefs.Create;
         JSONValue           := TJSONValue.Create;
         Try
          JSONValue.Encoding  := VEncondig;
          JSONValue.Encoded  := True;
          JSONValue.LoadFromJSON(ARequest.CustomHeaders.Values[tmp]);
          vdwConnectionDefs.LoadFromJSON(JSONValue.Value);
         Finally
          FreeAndNil(JSONValue);
         End;
        End
       Else If pos('dwservereventname', lowercase(tmp)) > 0  Then
        Begin
         JSONValue           := TJSONValue.Create;
         Try
          JSONValue.Encoding  := VEncondig;
          JSONValue.Encoded  := True;
          {$IFDEF FPC}
          JSONValue.DatabaseCharSet := vDatabaseCharSet;
          {$ENDIF}
          JSONValue.LoadFromJSON(ARequest.CustomHeaders.Values[tmp]);
          urlContext := JSONValue.Value;
          If Pos('.', urlContext) > 0 Then
           Begin
            baseEventUnit := Copy(urlContext, InitStrPos, Pos('.', urlContext) - 1 - FinalStrPos);
            urlContext    := Copy(urlContext, Pos('.', urlContext) + 1, Length(urlContext));
           End;
         Finally
          FreeAndNil(JSONValue);
         End;
        End
       Else
        Begin
         If Not Assigned(DWParams) Then
          Begin
           TServerUtils.ParseWebFormsParams (ARequest.ContentFields, Cmd, ARequest.Query,
                                             UrlMethod, urlContext, vmark, VEncondig{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}, DWParams);
           If DWParams.ItemsString['dwwelcomemessage'] <> Nil Then
            vWelcomeMessage := DecodeStrings(DWParams.ItemsString['dwwelcomemessage'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
           If (DWParams.ItemsString['dwaccesstag'] <> Nil) Then
            vAccessTag := DecodeStrings(DWParams.ItemsString['dwaccesstag'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
           If DWParams.ItemsString['datacompression'] <> Nil Then
            compresseddata := StringToBoolean(DWParams.ItemsString['datacompression'].AsString);
           If DWParams.ItemsString['dwencodestrings'] <> Nil Then
            encodestrings  := StringToBoolean(DWParams.ItemsString['dwencodestrings'].AsString);
           If DWParams.ItemsString['dwservereventname'] <> Nil Then
            urlContext := DWParams.ItemsString['dwservereventname'].AsString;
           If DWParams.ItemsString['dwusecript'] <> Nil Then
            vdwCriptKey  := StringToBoolean(DWParams.ItemsString['dwusecript'].AsString);
           If DWParams.ItemsString['dwassyncexec'] <> Nil Then
            dwassyncexec  := StringToBoolean(DWParams.ItemsString['dwassyncexec'].AsString);
           If DWParams.ItemsString['binaryrequest'] <> Nil Then
            vBinaryEvent   := StringToBoolean(DWParams.ItemsString['binaryrequest'].AsString);
           If DWParams.itemsstring['BinaryCompatibleMode'] <> Nil Then
            vBinaryCompatibleMode := DWParams.itemsstring['BinaryCompatibleMode'].value;
          End;
         JSONParam                 := TJSONParam.Create(DWParams.Encoding);
         JSONParam.ObjectDirection := odIN;
         JSONParam.ParamName       := lowercase(tmp);
         {$IFDEF FPC}
         JSONParam.DatabaseCharSet := vDatabaseCharSet;
         {$ENDIF}
         tmp                       := ARequest.CustomHeaders.Values[tmp];
         If (Pos(Lowercase('{"ObjectType":"toParam", "Direction":"'), Lowercase(tmp)) > 0) Then
          JSONParam.FromJSON(tmp)
         Else
          JSONParam.AsString  := StringReplace(tmp, sLineBreak, '', [rfReplaceAll]);
         DWParams.Add(JSONParam);
        End;
      End;
    End;
  Finally
   tmp := '';
  End;
  {$ELSE}

  {$ENDIF}
 End;
Begin
 vContentType          := '';
 vAccessTag            := '';
 vErrorMessage         := '';
 vIPVersion            := 'undefined';
 vBasePath             := FRootPath;
 JsonMode              := jmDataware;
 vErrorCode            := 200;
 dwassyncexec          := False;
 baseEventUnit         := '';
 vdwConnectionDefs     := Nil;
 vTempServerMethods    := Nil;
 DWParams              := Nil;
 mb                    := Nil;
 mb2                   := Nil;
 ServerContextStream   := Nil;
 compresseddata        := False;
 encodestrings         := False;
 vdwCriptKey           := False;
 vTagReply             := False;
 vBinaryEvent          := False;
 vBinaryCompatibleMode := False;
 vMetadata             := False;
 vServerContextCall    := False;
 vRequestHeader        := TStringList.Create;
 {$IFNDEF FPC}
  Cmd := Trim(ARequest.PathInfo);
  {$if CompilerVersion > 30}
   If vCORS Then
    Begin
     If vCORSCustomHeaders.Count > 0 Then
      Begin
       For I := 0 To vCORSCustomHeaders.Count -1 Do
        AResponse.CustomHeaders.AddPair(vCORSCustomHeaders.Names[I], vCORSCustomHeaders.ValueFromIndex[I]);
      End
     Else
      AResponse.CustomHeaders.AddPair('Access-Control-Allow-Origin', '*');
    End;
  {$ELSE}
   If vCORS Then
    Begin
     If vCORSCustomHeaders.Count > 0 Then
      Begin
       For I := 0 To vCORSCustomHeaders.Count -1 Do
        AResponse.CustomHeaders.Add(vCORSCustomHeaders[I]);
      End
     Else
      AResponse.CustomHeaders.Add('Access-Control-Allow-Origin=*');
    End;
  {$IFEND}
 {$ELSE}
  Cmd := Trim(ARequest.PathInfo);
  If vCORS Then
   Begin
    If (vCORSCustomHeaders.Count > 0) Then
     Begin
      For I := 0 To vCORSCustomHeaders.Count -1 Do
       AResponse.SetCustomHeader(vCORSCustomHeaders.Names[I], vCORSCustomHeaders.ValueFromIndex[I]);
     End
    Else
     AResponse.SetCustomHeader('Access-Control-Allow-Origin', '*');
   End;
 {$ENDIF}
 sCharSet := '';
 vContentStringStream := Nil;
 {$IFNDEF FPC}
  If ARequest.ContentLength > 0 Then
   Begin
   {$IF CompilerVersion > 29}
   ARequest.ReadTotalContent;
   If Length(ARequest.RawContent) > 0 Then
    Begin
     vContentStringStream := TStringStream.Create('');
     vContentStringStream.Write(TBytes(ARequest.RawContent),
                                Length(ARequest.RawContent));
     vContentStringStream.Position := 0;
     vRequestHeader.Text := vContentStringStream.DataString;
     vBinaryEvent := (Pos('"binarydata"', lowercase(vRequestHeader.Text)) > 0);
    End
   Else
   {$IFEND}
 {$ELSE}
 If (Trim(ARequest.Content) <> '') Then
  Begin
 {$ENDIF}
   vRequestHeader.Add(ARequest.Content);
   If vContentStringStream = Nil Then
    vContentStringStream := TStringStream.Create(ARequest.Content);
   vContentStringStream.Position := 0;
   If (pos('--', vContentStringStream.DataString) > 0) Then
    Begin
     vRequestHeader.Text := vContentStringStream.DataString;
     Try
      msgEnd   := False;
      {$IFNDEF FPC}
       {$IF (DEFINED(OLDINDY))}
        boundary := ExtractHeaderSubItem(ARequest.ContentType, 'boundary');
       {$ELSE}
        boundary := ExtractHeaderSubItem(ARequest.ContentType, 'boundary', QuoteHTTP);
       {$IFEND}
      {$ELSE}
       boundary := ExtractHeaderSubItem(ARequest.ContentType, 'boundary', QuoteHTTP);
      {$ENDIF}
      startboundary := '--' + boundary;
      Repeat
       tmp := ReadLnFromStream(vContentStringStream, -1, True);
      until tmp = startboundary;
     Finally
  //    vContentStringStream.Free;
     End;
    End;
  End;
 Try
  {$IFNDEF FPC}
   Cmd := stringreplace(Trim(lowercase(ARequest.PathInfo)), lowercase(vServerContext) + '/', '', [rfReplaceAll]);
  {$ELSE}
   Cmd := stringreplace(Trim(lowercase(ARequest.PathInfo)), lowercase(vServerContext) + '/', '', [rfReplaceAll]);
   If Cmd = ''  Then
    Cmd := stringreplace(Trim(lowercase(ARequest.HeaderLine)), lowercase(vServerContext) + '/', '', [rfReplaceAll]);
  {$ENDIF}
    If Not (vBinaryevent) Then
     If (Trim(ARequest.Content) = '') And (Cmd = '') then
      Exit;
    vRequestHeader.Add(Cmd);
    Cmd := StringReplace(Cmd, lowercase(' HTTP/1.0'), '', [rfReplaceAll]);
    Cmd := StringReplace(Cmd, lowercase(' HTTP/1.1'), '', [rfReplaceAll]);
    Cmd := StringReplace(Cmd, lowercase(' HTTP/2.0'), '', [rfReplaceAll]);
    Cmd := StringReplace(Cmd, lowercase(' HTTP/2.1'), '', [rfReplaceAll]);
    If (UpperCase(Copy (Cmd, 1, 7)) <> 'OPTIONS') And (vServerParams.HasAuthentication) Then
     Begin
      If ARequest.Authorization <> '' Then
       Begin
        vRequestHeader.Add(ARequest.Authorization);
        authDecode := DecodeStrings(StringReplace(ARequest.Authorization, 'Basic ', '', [rfReplaceAll])
                                    {$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
        If Not ((Pos(vServerParams.Username, authDecode) > 0) And
                (Pos(vServerParams.Password, authDecode) > 0)) Then
         Begin
          Handled := False;
          Exit;
         End;
       End;
     End;
    ReadRawHeaders;
    RequestType := rtGet;
    If (UpperCase(Trim(ARequest.Method))      = 'POST')   Then
     RequestType := rtPost
    Else If (UpperCase(Trim(ARequest.Method)) = 'PUT')    Then
     RequestType := rtPut
    Else If (UpperCase(Trim(ARequest.Method)) = 'DELETE') Then
     RequestType := rtDelete
    Else If (UpperCase(Trim(ARequest.Method)) = 'PATCH')  Then
     RequestType := rtPatch;
    If (RequestType In [rtPut, rtPatch]) Then //New Code to Put
     Begin
      If {$IFNDEF FPC}ARequest.ContentFields.Text{$ELSE}ARequest.ContentFields.Text{$ENDIF} <> '' Then
       Begin
        TServerUtils.ParseWebFormsParams (ARequest.ContentFields, Cmd, ARequest.Query,
                                          UrlMethod, urlContext, vmark, VEncondig{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}, DWParams);
        If DWParams.ItemsString['dwwelcomemessage'] <> Nil Then
         vWelcomeMessage       := DecodeStrings(DWParams.ItemsString['dwwelcomemessage'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
        If (DWParams.ItemsString['dwaccesstag'] <> Nil) Then
         vAccessTag            := DecodeStrings(DWParams.ItemsString['dwaccesstag'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
        If DWParams.ItemsString['datacompression'] <> Nil Then
         compresseddata        := StringToBoolean(DWParams.ItemsString['datacompression'].AsString);
        If DWParams.ItemsString['dwencodestrings'] <> Nil Then
         encodestrings         := StringToBoolean(DWParams.ItemsString['dwencodestrings'].AsString);
        If DWParams.ItemsString['dwservereventname'] <> Nil Then
         urlContext            := DecodeStrings(DWParams.ItemsString['dwservereventname'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
        If DWParams.ItemsString['dwusecript'] <> Nil Then
         vdwCriptKey           := StringToBoolean(DWParams.ItemsString['dwusecript'].AsString);
        If DWParams.ItemsString['dwassyncexec'] <> Nil Then
         dwassyncexec          := StringToBoolean(DWParams.ItemsString['dwassyncexec'].AsString);
        If DWParams.ItemsString['BinaryCompatibleMode'] <> Nil Then
         vBinaryCompatibleMode := DWParams.ItemsString['BinaryCompatibleMode'].Value;
       End;
     End;
    {$IFNDEF FPC}
    If ARequest.PathInfo <> '/favicon.ico' Then
    {$ELSE}
    If {$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequest.URI{$ENDIF} <> '/favicon.ico' Then
    {$ENDIF}
     Begin
    {$IFNDEF FPC}
     If (ARequest.QueryFields.Count > 0) And (RequestType In [rtGet, rtDelete]) Then
      Begin
       vTempCmd := Cmd;
       TServerUtils.ParseWebFormsParams (ARequest.QueryFields, vTempCmd,
                                         ARequest.Query,
                                         UrlMethod, urlContext, vmark, VEncondig,
                                         DWParams, ARequest.Method);
       If ARequest.Query <> '' Then
        Begin
         vTempCmd := vTempCmd + '?' + ARequest.Query;
         vRequestHeader.Add(vTempCmd);
         vRequestHeader.Add(ARequest.QueryFields.Text);
        End
       Else
        vRequestHeader.Add(vTempCmd);
       Cmd := vTempCmd;
       If DWParams <> Nil Then
        Begin
         If DWParams.ItemsString['dwwelcomemessage'] <> Nil Then
          vWelcomeMessage       := DecodeStrings(DWParams.ItemsString['dwwelcomemessage'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
         If (DWParams.ItemsString['dwaccesstag'] <> Nil) Then
          vAccessTag            := DecodeStrings(DWParams.ItemsString['dwaccesstag'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
         If DWParams.ItemsString['datacompression'] <> Nil Then
          compresseddata        := StringToBoolean(DWParams.ItemsString['datacompression'].AsString);
         If DWParams.ItemsString['dwencodestrings'] <> Nil Then
          encodestrings         := StringToBoolean(DWParams.ItemsString['dwencodestrings'].AsString);
         If DWParams.ItemsString['dwservereventname'] <> Nil Then
          urlContext            := DecodeStrings(DWParams.ItemsString['dwservereventname'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
         If DWParams.ItemsString['dwusecript'] <> Nil Then
          vdwCriptKey           := StringToBoolean(DWParams.ItemsString['dwusecript'].AsString);
         If DWParams.ItemsString['dwassyncexec'] <> Nil Then
          dwassyncexec          := StringToBoolean(DWParams.ItemsString['dwassyncexec'].AsString);
         If DWParams.ItemsString['binaryrequest'] <> Nil Then
          vBinaryEvent          := StringToBoolean(DWParams.ItemsString['binaryrequest'].AsString);
         If DWParams.ItemsString['BinaryCompatibleMode'] <> Nil Then
          vBinaryCompatibleMode := DWParams.ItemsString['BinaryCompatibleMode'].Value;
        End;
      End
    {$ELSE}
     If (ARequest.FieldCount > 0) And //(Trim(ARequest.ContentFields.Text) <> '')) And
         (Trim(ARequest.Content) = '') Then
      Begin
       vRequestHeader.Add(ARequest.ContentFields.Text);
       vRequestHeader.Add(Cmd);
       vRequestHeader.Add(ARequest.Query);
       TServerUtils.ParseWebFormsParams (ARequest.ContentFields, Cmd, ARequest.Query,
                                         UrlMethod, urlContext, vmark, VEncondig{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}, DWParams);
//       SaveLog; //For Debbug Vars
       If DWParams <> Nil Then
        Begin
         If DWParams.ItemsString['dwwelcomemessage'] <> Nil Then
          vWelcomeMessage       := DecodeStrings(DWParams.ItemsString['dwwelcomemessage'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
         If (DWParams.ItemsString['dwaccesstag'] <> Nil) Then
          vAccessTag            := DecodeStrings(DWParams.ItemsString['dwaccesstag'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
         If DWParams.ItemsString['datacompression'] <> Nil Then
          compresseddata        := StringToBoolean(DWParams.ItemsString['datacompression'].AsString);
         If DWParams.ItemsString['dwencodestrings'] <> Nil Then
          encodestrings         := StringToBoolean(DWParams.ItemsString['dwencodestrings'].AsString);
         If DWParams.ItemsString['dwservereventname'] <> Nil Then
          urlContext            := DWParams.ItemsString['dwservereventname'].AsString;
         If DWParams.ItemsString['dwusecript'] <> Nil Then
          vdwCriptKey           := StringToBoolean(DWParams.ItemsString['dwusecript'].AsString);
         If DWParams.ItemsString['dwassyncexec'] <> Nil Then
          dwassyncexec          := StringToBoolean(DWParams.ItemsString['dwassyncexec'].AsString);
         If DWParams.ItemsString['binaryrequest'] <> Nil Then
          vBinaryEvent          := StringToBoolean(DWParams.ItemsString['binaryrequest'].AsString);
         If DWParams.ItemsString['BinaryCompatibleMode'] <> Nil Then
          vBinaryCompatibleMode := DWParams.ItemsString['BinaryCompatibleMode'].Value;
        End;
      End
    {$ENDIF}
      Else
       Begin
        If (((vContentStringStream <> Nil) And (Trim(vContentStringStream.Datastring) <> ''))
            Or (Trim(ARequest.Content) = '')) And (RequestType In [rtGet, rtDelete]) Then
         Begin
//          SaveLog; //For Debbug Vars
          aurlContext := urlContext;
          {$IFDEF FPC}
           If Trim(ARequest.Query) <> '' Then
            Begin
             vRequestHeader.Add(ARequest.PathInfo + '?' + ARequest.Query);
             TServerUtils.ParseRESTURL (ARequest.PathInfo + '?' + ARequest.Query, VEncondig, UrlMethod, urlContext, vmark{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}, DWParams);
            End
           Else
            Begin
             vRequestHeader.Add(ARequest.PathInfo);
             TServerUtils.ParseRESTURL (ARequest.PathInfo, VEncondig, UrlMethod, urlContext, vmark{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}, DWParams);
            End;
          {$ELSE}
          vRequestHeader.Add(ARequest.PathInfo + ARequest.Query);
          TServerUtils.ParseRESTURL (ARequest.PathInfo + ARequest.Query, VEncondig, UrlMethod, urlContext, vmark, DWParams);
          {$ENDIF}
          If (urlContext = '') And (aurlContext <> '') Then
           urlContext := aurlContext;
          vOldMethod := UrlMethod;
          If DWParams <> Nil Then
           Begin
            If DWParams.ItemsString['dwwelcomemessage'] <> Nil Then
             vWelcomeMessage       := DecodeStrings(DWParams.ItemsString['dwwelcomemessage'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
            If (DWParams.ItemsString['dwaccesstag'] <> Nil) Then
             vAccessTag            := DecodeStrings(DWParams.ItemsString['dwaccesstag'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
            If DWParams.ItemsString['datacompression'] <> Nil Then
             compresseddata        := StringToBoolean(DWParams.ItemsString['datacompression'].AsString);
            If DWParams.ItemsString['dwencodestrings'] <> Nil Then
             encodestrings         := StringToBoolean(DWParams.ItemsString['dwencodestrings'].AsString);
            If DWParams.ItemsString['dwservereventname'] <> Nil Then
             urlContext            := DWParams.ItemsString['dwservereventname'].AsString;
            If DWParams.ItemsString['dwusecript'] <> Nil Then
             vdwCriptKey           := StringToBoolean(DWParams.ItemsString['dwusecript'].AsString);
            If DWParams.ItemsString['dwassyncexec'] <> Nil Then
             dwassyncexec          := StringToBoolean(DWParams.ItemsString['dwassyncexec'].AsString);
            If DWParams.ItemsString['binaryrequest'] <> Nil Then
             vBinaryEvent          := StringToBoolean(DWParams.ItemsString['binaryrequest'].AsString);
            If DWParams.ItemsString['BinaryCompatibleMode'] <> Nil Then
             vBinaryCompatibleMode := DWParams.ItemsString['BinaryCompatibleMode'].Value;
           End;
         End
        Else
         Begin
          ServerContextStream := Nil;
          If vContentStringStream = Nil Then
           Begin
            vContentStringStream := TStringStream.Create(ARequest.Content);
            vRequestHeader.Add(ARequest.Content);
            vContentStringStream.Position := 0;
           End;
          If (vContentStringStream.Size > 0) And (boundary <> '') Then
           Begin
       //     Savelog('boundary 3 : ' + boundary);
       //     Savelog(vContentStringStream.DataString);
            Try
             Repeat
              decoder              := TIdMessageDecoderMIME.Create(nil);
              TIdMessageDecoderMIME(decoder).MIMEBoundary := boundary;
              Try
               decoder.SourceStream := vContentStringStream;
               decoder.FreeSourceStream := False;
              finally
              end;
              decoder.ReadHeader;
              Case Decoder.PartType of
               mcptAttachment,
               mcptText :
                Begin
                 If ((Decoder.PartType = mcptAttachment) And
                     (boundary <> ''))                   Then
                  Begin
                   sFile := '';
                   {$IFDEF FPC}
                    ms := TStringStream.Create('');
                   {$ELSE}
                    ms := TStringStream.Create(''{$if CompilerVersion > 21}, TEncoding.UTF8{$IFEND});
                   {$ENDIF}
                   tmp         := Decoder.Headers.Text;
                   newdecoder  := Decoder.ReadBody(ms, msgEnd);
                   ms.Position := 0;
                   FreeAndNil(Decoder);
                   Decoder     := newdecoder;
                   If Decoder <> Nil Then
                    TIdMessageDecoderMIME(Decoder).MIMEBoundary := Boundary;
                   vObjectName := Copy(lowercase(tmp), Pos('; name="', lowercase(tmp)) + length('; name="'),  length(lowercase(tmp)));
                   vObjectName := Copy(vObjectName, InitStrPos, Pos('"', vObjectName) -1);
                   If (lowercase(vObjectName) = 'binarydata') then
                    Begin
                     If (DWParams = Nil) Then
                      Begin
                       aurlContext := urlContext;
                       {$IFNDEF FPC}
                       If (ARequest.QueryFields.Count = 0) Then
                       {$ELSE}
                       If (ARequest.FieldCount = 0) Then
                       {$ENDIF}
                        Begin
                         DWParams           := TDWParams.Create;
                         DWParams.Encoding  := VEncondig;
                        End
                       Else
                        Begin
                         {$IFDEF FPC}
                          If Trim(ARequest.Query) <> '' Then
                           TServerUtils.ParseRESTURL (ARequest.PathInfo + '?' + ARequest.Query, VEncondig, UrlMethod, urlContext, vmark{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}, DWParams)
                          Else
                           TServerUtils.ParseRESTURL (ARequest.PathInfo, VEncondig, UrlMethod, urlContext, vmark{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}, DWParams);
                         {$ELSE}
                          If Trim(ARequest.Query) <> '' Then
                           TServerUtils.ParseRESTURL (ARequest.PathInfo + '?' + ARequest.Query, VEncondig, UrlMethod, urlContext, vmark, DWParams)
                          Else
                           TServerUtils.ParseRESTURL (ARequest.PathInfo, VEncondig, UrlMethod, urlContext, vmark, DWParams);
                         {$ENDIF}
                        End;
                      End;
                     If (urlContext = '') And (aurlContext <> '') Then
                      urlContext := aurlContext;
                     Try
                      ms.Position := 0;
                      DWParams.LoadFromStream(ms);
                      {$IFNDEF FPC}ms.Size := 0;{$ENDIF}
                      If Assigned(ms) Then
                       FreeAndNil(ms);
                     Except
                      On E : Exception Do
                       Begin
                        //savelog(vObjectName + ' : ' + e.Message);
                       End;
                     End;
                     If Assigned(ms) Then
                      FreeAndNil(ms);
                     If Assigned(newdecoder) Then
                      FreeAndNil(newdecoder);
                     If DWParams <> Nil Then
                      Begin
                       If DWParams.ItemsString['dwwelcomemessage'] <> Nil Then
                        vWelcomeMessage := DecodeStrings(DWParams.ItemsString['dwwelcomemessage'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
                       If (DWParams.ItemsString['dwaccesstag'] <> Nil) Then
                        vAccessTag := DecodeStrings(DWParams.ItemsString['dwaccesstag'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
                       If DWParams.ItemsString['datacompression'] <> Nil Then
                        compresseddata := StringToBoolean(DWParams.ItemsString['datacompression'].AsString);
                       If DWParams.ItemsString['dwencodestrings'] <> Nil Then
                        encodestrings  := StringToBoolean(DWParams.ItemsString['dwencodestrings'].AsString);
                       If DWParams.ItemsString['dwservereventname'] <> Nil Then
                        urlContext := DWParams.ItemsString['dwservereventname'].AsString;
                       If DWParams.ItemsString['dwusecript'] <> Nil Then
                        vdwCriptKey  := StringToBoolean(DWParams.ItemsString['dwusecript'].AsString);
                       If DWParams.ItemsString['dwassyncexec'] <> Nil Then
                        dwassyncexec  := StringToBoolean(DWParams.ItemsString['dwassyncexec'].AsString);
                       If DWParams.ItemsString['binaryrequest'] <> Nil Then
                        vBinaryEvent   := StringToBoolean(DWParams.ItemsString['binaryrequest'].AsString);
                       If DWParams.ItemsString['BinaryCompatibleMode'] <> Nil Then
                        vBinaryCompatibleMode := DWParams.ItemsString['BinaryCompatibleMode'].Value;
                      End;
                   //  savelog(DWParams.ToJSON);
                     Continue;
                    End;
                   If (DWParams = Nil) Then
                    Begin
                     aurlContext := urlContext;
                     {$IFNDEF FPC}
                     If (ARequest.QueryFields.Count = 0) Then
                     {$ELSE}
                     If (ARequest.FieldCount = 0) Then
                     {$ENDIF}
                      Begin
                       DWParams           := TDWParams.Create;
                       DWParams.Encoding  := VEncondig;
                      End
                     Else
                      Begin
                       {$IFDEF FPC}
                        If Trim(ARequest.Query) <> '' Then
                         TServerUtils.ParseRESTURL (ARequest.PathInfo + '?' + ARequest.Query, VEncondig, UrlMethod, urlContext, vmark{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}, DWParams)
                        Else
                         TServerUtils.ParseRESTURL (ARequest.PathInfo, VEncondig, UrlMethod, urlContext, vmark{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}, DWParams);
                       {$ELSE}
                        If Trim(ARequest.Query) <> '' Then
                         TServerUtils.ParseRESTURL (ARequest.PathInfo + '?' + ARequest.Query, VEncondig, UrlMethod, urlContext, vmark, DWParams)
                        Else
                         TServerUtils.ParseRESTURL (ARequest.PathInfo, VEncondig, UrlMethod, urlContext, vmark, DWParams);
                       {$ENDIF}
                      End;
                     If (urlContext = '') And (aurlContext <> '') Then
                      urlContext := aurlContext;
                    End;
                   If sFile <> '' Then
                    Begin
                     vObjectName := 'dwfilename';
                     JSONParam   := TJSONParam.Create(DWParams.Encoding);
                     JSONParam.ObjectDirection := odIN;
                     JSONParam.ParamName := vObjectName;
                     JSONParam.SetValue(sFile, JSONParam.Encoded);
                     DWParams.Add(JSONParam);
                    End;
                   {$IFDEF FPC}
                   If Not Assigned(DWParams) Then
                    Begin
                     DWParams           := TDWParams.Create;
                     DWParams.Encoding  := VEncondig;
                    End;
                   If (ARequest.ContentFields.Count > 0) Then
                    Begin
                     For I := 0 To ARequest.ContentFields.Count -1 Do
                      Begin
                       JSONParam           := TJSONParam.Create(DWParams.Encoding);
                       JSONParam.ObjectDirection := odIN;
                       JSONParam.ParamName := ARequest.ContentFields.Names[I];
                       If VEncondig = esUtf8 Then
                        JSONParam.SetValue(utf8decode(ARequest.ContentFields.Values[JSONParam.ParamName]), JSONParam.Encoded)
                       Else
                        JSONParam.SetValue(ARequest.ContentFields.Values[JSONParam.ParamName], JSONParam.Encoded);
                       DWParams.Add(JSONParam);
                      End;
                    End;
                   {$ELSE}
                   If (ARequest.QueryFields.Count = 0) And
                      (ARequest.ContentFields.Count > 0) Then
                    Begin
                     I := 0;
                     While I <= ARequest.ContentFields.Count -1 Do
                      Begin
                       If (ARequest.ContentFields.Names[0] <> '') Then
                        Break;
                       If (ARequest.ContentFields.Names[I] <> '') Then
                        Begin
                         JSONParam           := TJSONParam.Create(DWParams.Encoding);
                         JSONParam.ObjectDirection := odIN;
                         tmp := ARequest.ContentFields[I];
                         If Pos('; name="', lowercase(tmp)) > 0 Then
                          Begin
                           vObjectName := Copy(lowercase(tmp), Pos('; name="', lowercase(tmp)) + length('; name="'),  length(lowercase(tmp)));
                           vObjectName := Copy(vObjectName, InitStrPos, Pos('"', vObjectName) -1);
                           JSONParam.ParamName := vObjectName;
                           If (I+1 <= (ARequest.ContentFields.Count -1)) Then
                            Begin
                             If VEncondig = esUtf8 Then
                              JSONParam.SetValue(utf8decode(ARequest.ContentFields[I +1]), JSONParam.Encoded)
                             Else
                              JSONParam.SetValue(ARequest.ContentFields[I +1], JSONParam.Encoded);
                            End;
                           Inc(I);
                           DWParams.Add(JSONParam);
                          End;
                        End;
                       Inc(I);
                      End;
                     //Quebra de Form-Data
                     For I := 0 To ARequest.ContentFields.Count -1 Do
                      Begin
                       If (ARequest.ContentFields.Names[0] = '') Then
                        Break;
                       JSONParam           := TJSONParam.Create(DWParams.Encoding);
                       JSONParam.ObjectDirection := odIN;
                       JSONParam.ParamName := ARequest.ContentFields.Names[I];
                       If VEncondig = esUtf8 Then
                        JSONParam.SetValue(utf8decode(ARequest.ContentFields.Values[JSONParam.ParamName]), JSONParam.Encoded)
                       Else
                        JSONParam.SetValue(ARequest.ContentFields.Values[JSONParam.ParamName], JSONParam.Encoded);
                       DWParams.Add(JSONParam);
                      End;
                    End;
                   {$ENDIF}
                   If Assigned(Decoder) Then
                    FreeAndNil(Decoder);
                  End
                 Else If Boundary <> '' Then
                  Begin
                  {$IFDEF FPC}
                   ms := TStringStream.Create('');
                  {$ELSE}
                   ms := TStringStream.Create(''{$if CompilerVersion > 21}, TEncoding.UTF8{$IFEND});
                  {$ENDIF}
                   ms.Position := 0;
                   newdecoder  := Decoder.ReadBody(ms, msgEnd);
                   tmp         := Decoder.Headers.Text;
                   FreeAndNil(Decoder);
                   Decoder     := newdecoder;
//                   SaveLog(tmp);
                   If Decoder <> Nil Then
                    TIdMessageDecoderMIME(Decoder).MIMEBoundary := Boundary;
                   If pos('dwwelcomemessage', lowercase(tmp)) > 0 Then
                    vWelcomeMessage := DecodeStrings(ms.DataString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF})
                   Else If pos('dwaccesstag', lowercase(tmp)) > 0 Then
                    vAccessTag := DecodeStrings(ms.DataString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF})
                   Else If Pos('dwusecript', lowercase(tmp)) > 0 Then
                    vdwCriptKey  := StringToBoolean(ms.DataString)
                   Else If pos('datacompression', lowercase(tmp)) > 0 Then
                    compresseddata := StringToBoolean(ms.DataString)
                   Else If pos('dwencodestrings', lowercase(tmp)) > 0 Then
                    encodestrings  := StringToBoolean(ms.DataString)
                   Else If Pos('dwassyncexec', lowercase(tmp)) > 0 Then
                    dwassyncexec := StringToBoolean(ms.DataString)
                   Else If Pos('binaryrequest', lowercase(tmp)) > 0 Then
                    vBinaryEvent := StringToBoolean(ms.DataString)
                   Else If Pos('BinaryCompatibleMode', lowercase(tmp)) > 0 Then
                    vBinaryCompatibleMode := StringToBoolean(ms.DataString)
                   Else If pos('dwconnectiondefs', lowercase(tmp)) > 0 Then
                    Begin
                     vdwConnectionDefs   := TConnectionDefs.Create;
                     JSONValue           := TJSONValue.Create;
                     Try
                      JSONValue.Encoding  := VEncondig;
                      JSONValue.Encoded  := True;
                      JSONValue.LoadFromJSON(ms.DataString);
                      vdwConnectionDefs.LoadFromJSON(JSONValue.Value);
                     Finally
                      FreeAndNil(JSONValue);
                     End;
                    End
                   Else If pos('dwservereventname', lowercase(tmp)) > 0  Then
                    Begin
                     //SaveLog(tmp);
                     JSONValue           := TJSONValue.Create;
                     Try
                      JSONValue.Encoding := VEncondig;
                      JSONValue.Encoded  := True;
                      JSONValue.LoadFromJSON(ms.DataString);
                      urlContext := JSONValue.Value;
                      If Pos('.', urlContext) > 0 Then
                       Begin
                        baseEventUnit := Copy(urlContext, InitStrPos, Pos('.', urlContext) - 1 - FinalStrPos);
                        urlContext    := Copy(urlContext, Pos('.', urlContext) + 1, Length(urlContext));
                       End;
                     Finally
                      FreeAndNil(JSONValue);
                     End;
                    End
                   Else
                    Begin
                     aurlContext := urlContext;
                     {$IFDEF FPC}
                      If Trim(ARequest.Query) <> '' Then
                       TServerUtils.ParseRESTURL (ARequest.PathInfo + '?' + ARequest.Query, VEncondig, UrlMethod, urlContext, vmark{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}, DWParams)
                      Else
                       TServerUtils.ParseRESTURL (ARequest.PathInfo, VEncondig, UrlMethod, urlContext, vmark{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}, DWParams);
                     {$ELSE}
                      If Trim(ARequest.Query) <> '' Then
                       TServerUtils.ParseRESTURL (ARequest.PathInfo + '?' + ARequest.Query, VEncondig, UrlMethod, urlContext, vmark, DWParams)
                      Else
                       TServerUtils.ParseRESTURL (ARequest.PathInfo, VEncondig, UrlMethod, urlContext, vmark, DWParams);
                     {$ENDIF}
                     If (urlContext = '') And (aurlContext <> '') Then
                      urlContext := aurlContext;
//                     savelog(tmp);
                     vObjectName := Copy(lowercase(tmp), Pos('; name="', lowercase(tmp)) + length('; name="'),  length(lowercase(tmp)));
                     vObjectName := Copy(vObjectName, InitStrPos, Pos('"', vObjectName) -1);
                     //savelog('ObjectName : ' + vObjectName);
                     JSONParam   := TJSONParam.Create(DWParams.Encoding);
                     JSONParam.ObjectDirection := odIN;
                     If (lowercase(vObjectName) = 'binarydata') then
                      Begin
                       DWParams.LoadFromStream(ms);
                       If Assigned(JSONParam) Then
                        FreeAndNil(JSONParam);
                       {$IFNDEF FPC}ms.Size := 0;{$ENDIF}
                       FreeAndNil(ms);
                       If DWParams <> Nil Then
                        Begin
                         If DWParams.ItemsString['dwwelcomemessage'] <> Nil Then
                          vWelcomeMessage := DecodeStrings(DWParams.ItemsString['dwwelcomemessage'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
                         If (DWParams.ItemsString['dwaccesstag'] <> Nil) Then
                          vAccessTag := DecodeStrings(DWParams.ItemsString['dwaccesstag'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
                         If DWParams.ItemsString['datacompression'] <> Nil Then
                          compresseddata := StringToBoolean(DWParams.ItemsString['datacompression'].AsString);
                         If DWParams.ItemsString['dwencodestrings'] <> Nil Then
                          encodestrings  := StringToBoolean(DWParams.ItemsString['dwencodestrings'].AsString);
                         If DWParams.ItemsString['dwservereventname'] <> Nil Then
                          urlContext := DWParams.ItemsString['dwservereventname'].AsString;
                         If DWParams.ItemsString['dwusecript'] <> Nil Then
                          vdwCriptKey  := StringToBoolean(DWParams.ItemsString['dwusecript'].AsString);
                         If DWParams.ItemsString['dwassyncexec'] <> Nil Then
                          dwassyncexec  := StringToBoolean(DWParams.ItemsString['dwassyncexec'].AsString);
                         If DWParams.ItemsString['binaryrequest'] <> Nil Then
                          vBinaryEvent   := StringToBoolean(DWParams.ItemsString['binaryrequest'].AsString);
                         If DWParams.ItemsString['BinaryCompatibleMode'] <> Nil Then
                          vBinaryCompatibleMode := DWParams.ItemsString['BinaryCompatibleMode'].Value;
                        End;
                       Continue;
                      End;
                     If (Pos(Lowercase('{"ObjectType":"toParam", "Direction":"'), lowercase(ms.DataString)) > 0) Then
                      JSONParam.FromJSON(ms.DataString)
                     Else
                      JSONParam.AsString := StringReplace(StringReplace(ms.DataString, sLineBreak, '', [rfReplaceAll]), #13, '', [rfReplaceAll]);
                     JSONParam.ParamName := vObjectName;
                     DWParams.Add(JSONParam);
                     If (DWParams.ItemsString['dwaccesstag'] <> Nil) Then
                      vAccessTag := DecodeStrings(DWParams.ItemsString['dwaccesstag'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
                    End;
                   {$IFNDEF FPC}ms.Size := 0;{$ENDIF}
                   FreeAndNil(ms);
                  End
                 Else
                  Begin
                   aurlContext := urlContext;
                   {$IFDEF FPC}
                    If Trim(ARequest.Query) <> '' Then
                     Begin
                      vRequestHeader.Add(ARequest.PathInfo + '?' + ARequest.Query);
                      TServerUtils.ParseRESTURL (ARequest.PathInfo + '?' + ARequest.Query, VEncondig, UrlMethod, urlContext, vmark{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}, DWParams);
                     End
                    Else
                     Begin
                      vRequestHeader.Add(ARequest.PathInfo);
                      TServerUtils.ParseRESTURL (ARequest.PathInfo, VEncondig, UrlMethod, urlContext, vmark{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}, DWParams);
                     End;
                   {$ELSE}
                    If Trim(ARequest.Query) <> '' Then
                     Begin
                      vRequestHeader.Add(ARequest.PathInfo + '?' + ARequest.Query);
                      TServerUtils.ParseRESTURL (ARequest.PathInfo + '?' + ARequest.Query, VEncondig, UrlMethod, urlContext, vmark, DWParams);
                     End
                    Else
                     Begin
                      vRequestHeader.Add(ARequest.PathInfo);
                      TServerUtils.ParseRESTURL (ARequest.PathInfo, VEncondig, UrlMethod, urlContext, vmark, DWParams);
                     End;
                   {$ENDIF}
                   If (DWParams.ItemsString['dwaccesstag'] <> Nil) Then
                    vAccessTag := DecodeStrings(DWParams.ItemsString['dwaccesstag'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
                   If (urlContext = '') And (aurlContext <> '') Then
                    urlContext := aurlContext;
                   FreeAndNil(decoder);
                  End;
                End;
               mcptIgnore :
                Begin
                 Try
                  If decoder <> Nil Then
                   FreeAndNil(decoder);
                  decoder := TIdMessageDecoderMIME.Create(Nil);
                  TIdMessageDecoderMIME(decoder).MIMEBoundary := boundary;
                 Finally
                 End;
                End;
               {$IFNDEF FPC}
                {$IF Not(DEFINED(OLDINDY))}
                mcptEOF:
                 Begin
                  FreeAndNil(decoder);
                  msgEnd := True
                 End;
                {$IFEND}
               {$ELSE}
               mcptEOF:
                Begin
                 FreeAndNil(decoder);
                 msgEnd := True
                End;
               {$ENDIF}
               End;
             Until (Decoder = Nil) Or (msgEnd);
            Finally
             If decoder <> nil then
              FreeAndNil(decoder);
             If vContentStringStream <> Nil Then
              FreeAndNil(vContentStringStream);
            End;
           End
          Else
           Begin
            aurlContext := urlContext;
            {$IFDEF FPC}
             If Trim(ARequest.Query) <> '' Then
              Begin
               vRequestHeader.Add(ARequest.PathInfo + '?' + ARequest.Query);
               TServerUtils.ParseRESTURL (ARequest.PathInfo + '?' + ARequest.Query, VEncondig, UrlMethod, urlContext, vmark{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}, DWParams);
              End
             Else
              Begin
               vRequestHeader.Add(ARequest.PathInfo);
               TServerUtils.ParseRESTURL (ARequest.PathInfo, VEncondig, UrlMethod, urlContext, vmark{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}, DWParams);
              End;
            {$ELSE}
             If Trim(ARequest.Query) <> '' Then
              Begin
               vRequestHeader.Add(ARequest.PathInfo + '?' + ARequest.Query);
               TServerUtils.ParseRESTURL (ARequest.PathInfo + '?' + ARequest.Query, VEncondig, UrlMethod, urlContext, vmark, DWParams);
              End
             Else
              Begin
               vRequestHeader.Add(ARequest.PathInfo);
               TServerUtils.ParseRESTURL (ARequest.PathInfo, VEncondig, UrlMethod, urlContext, vmark, DWParams);
              End;
            {$ENDIF}
            If (DWParams.ItemsString['dwaccesstag'] <> Nil) Then
             vAccessTag := DecodeStrings(DWParams.ItemsString['dwaccesstag'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
            If vContentStringStream <> Nil Then
             FreeAndNil(vContentStringStream);
            If (urlContext = '') And (aurlContext <> '') Then
             urlContext := aurlContext;
            {$IFNDEF FPC}
             {$IF CompilerVersion > 30}
              ARequest.ReadTotalContent;
              If vContentStringStream = Nil Then
               If VEncondig = esUtf8 Then
                vContentStringStream := TStringStream.Create(TEncoding.UTF8.GetString(ARequest.RawContent))
               Else
                vContentStringStream := TStringStream.Create(TEncoding.ANSI.GetString(ARequest.RawContent));
              vRequestHeader.Add(vContentStringStream.DataString);
             {$ELSE}
              If vContentStringStream = Nil Then
               vContentStringStream := TStringStream.Create(ARequest.Content);
              vContentStringStream.Position := 0;
              vRequestHeader.Add(ARequest.Content);
             {$IFEND}
            {$ELSE}
             If vContentStringStream = Nil Then
              If VEncondig = esUtf8 Then
               vContentStringStream := TStringStream.Create(Utf8Decode(ARequest.Content))
              Else
               vContentStringStream := TStringStream.Create(ARequest.Content);
             vContentStringStream.Position := 0;
             vRequestHeader.Add(ARequest.Content);
            {$ENDIF}
            If vContentStringStream.Size > 0 Then
             Begin
              vParamList := TStringList.Create;
              vParamList.Text := vContentStringStream.DataString;
              If (Not TServerUtils.ParseDWParamsURL(vContentStringStream.DataString, VEncondig, DWParams{$IFDEF FPC}, vDatabaseCharSet{$ENDIF})) And
                 (vParamList.Count > 0) Then
               Begin
                For I := 0 To vParamList.Count -1 Do
                 Begin
                  tmp := Trim(vParamList.Names[I]);
                  If tmp = '' Then
                   tmp := cUndefined;
                  If pos('dwwelcomemessage', lowercase(tmp)) > 0 Then
                   vWelcomeMessage := DecodeStrings(vParamList.Values[tmp]{$IFDEF FPC}, vDatabaseCharSet{$ENDIF})
                  Else If pos('dwaccesstag', lowercase(tmp)) > 0 Then
                   vAccessTag := DecodeStrings(vParamList.Values[tmp]{$IFDEF FPC}, vDatabaseCharSet{$ENDIF})
                  Else If pos('datacompression', lowercase(tmp)) > 0 Then
                   compresseddata := StringToBoolean(vParamList.Values[tmp])
                  Else If pos('dwencodestrings', lowercase(tmp)) > 0 Then
                   encodestrings  := StringToBoolean(vParamList.Values[tmp])
                  Else If Pos('dwassyncexec', lowercase(tmp)) > 0 Then
                   dwassyncexec := StringToBoolean(ms.DataString)
                  Else If Pos('dwusecript', lowercase(tmp)) > 0 Then
                   vdwCriptKey  := StringToBoolean(ms.DataString)
                  Else If Pos('BinaryCompatibleMode', lowercase(tmp)) > 0 Then
                   vBinaryCompatibleMode := StringToBoolean(ms.DataString)
                  Else If pos('dwconnectiondefs', lowercase(tmp)) > 0 Then
                   Begin
                    vdwConnectionDefs   := TConnectionDefs.Create;
                    JSONValue           := TJSONValue.Create;
                    Try
                     JSONValue.Encoding  := VEncondig;
                     JSONValue.Encoded  := True;
                     JSONValue.LoadFromJSON(vParamList.Values[tmp]);
                     vdwConnectionDefs.LoadFromJSON(JSONValue.Value);
                    Finally
                     FreeAndNil(JSONValue);
                    End;
                   End
                  Else If pos('dwservereventname', lowercase(tmp)) > 0  Then
                   Begin
                    JSONValue           := TJSONValue.Create;
                    Try
                     JSONValue.Encoding := VEncondig;
                     JSONValue.Encoded  := True;
                     JSONValue.LoadFromJSON(vParamList.Values[tmp]);
                     urlContext := JSONValue.Value;
                     If Pos('.', urlContext) > 0 Then
                      Begin
                       baseEventUnit := Copy(urlContext, InitStrPos, Pos('.', urlContext) - 1 - FinalStrPos);
                       urlContext    := Copy(urlContext, Pos('.', urlContext) + 1, Length(urlContext));
                      End;
                    Finally
                     FreeAndNil(JSONValue);
                    End;
                   End
                  Else
                   Begin
                    If DWParams = Nil Then
                     Begin
                      DWParams           := TDWParams.Create;
                      DWParams.Encoding  := VEncondig;
                     End;
                    JSONParam                 := TJSONParam.Create(DWParams.Encoding);
                    JSONParam.ObjectDirection := odIN;
                    JSONParam.ParamName       := lowercase(tmp);
                    If (lowercase(JSONParam.ParamName) = 'binarydata') then
                     Begin
                      ms := TStringStream.Create(vParamList.Values[tmp]);
                      ms.Position := 0;
                      DWParams.LoadFromStream(ms);
                      If Assigned(JSONParam) Then
                       FreeAndNil(JSONParam);
                      If DWParams.ItemsString['dwwelcomemessage'] <> Nil Then
                       vWelcomeMessage := DecodeStrings(DWParams.ItemsString['dwwelcomemessage'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
                      If (DWParams.ItemsString['dwaccesstag'] <> Nil) Then
                       vAccessTag := DecodeStrings(DWParams.ItemsString['dwaccesstag'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
                      If DWParams.ItemsString['datacompression'] <> Nil Then
                       compresseddata := StringToBoolean(DWParams.ItemsString['datacompression'].AsString);
                      If DWParams.ItemsString['dwencodestrings'] <> Nil Then
                       encodestrings  := StringToBoolean(DWParams.ItemsString['dwencodestrings'].AsString);
                      If DWParams.ItemsString['dwservereventname'] <> Nil Then
                       urlContext := DWParams.ItemsString['dwservereventname'].AsString;
                      If DWParams.ItemsString['dwusecript'] <> Nil Then
                       vdwCriptKey  := StringToBoolean(DWParams.ItemsString['dwusecript'].AsString);
                      If DWParams.ItemsString['dwassyncexec'] <> Nil Then
                       dwassyncexec  := StringToBoolean(DWParams.ItemsString['dwassyncexec'].AsString);
                      If DWParams.ItemsString['binaryrequest'] <> Nil Then
                       vBinaryEvent   := StringToBoolean(DWParams.ItemsString['binaryrequest'].AsString);
                      If DWParams.ItemsString['BinaryCompatibleMode'] <> Nil Then
                       vBinaryCompatibleMode := DWParams.ItemsString['BinaryCompatibleMode'].Value;
                      Continue;
                     End
                    Else
                     Begin
                      If tmp = cUndefined Then
                       Begin
                        tmp := vParamList.ValueFromIndex[I];
                        JSONParam.AsString  := tmp;
                       End
                      Else
                       Begin
                        {$IFNDEF FPC}
                         {$IF (DEFINED(OLDINDY))}
                          tmp := TIdURI.URLDecode(StringReplace(vParamList.Values[tmp], '+', ' ', [rfReplaceAll]));
                         {$ELSE}
                          tmp := TIdURI.URLDecode(StringReplace(vParamList.Values[tmp], '+', ' ', [rfReplaceAll]), GetEncodingID(DWParams.Encoding));
                         {$IFEND}
                        {$ELSE}
                         tmp := TIdURI.URLDecode(StringReplace(vParamList.Values[tmp], '+', ' ', [rfReplaceAll]), GetEncodingID(DWParams.Encoding));
                        {$ENDIF}
                        If Pos(LowerCase('{"ObjectType":"toParam", "Direction":"'), LowerCase(tmp)) = InitStrPos Then
                         JSONParam.FromJSON(tmp)
                        Else
                         Begin
                          If VEncondig = esUtf8 Then
                           JSONParam.AsString  := utf8decode(tmp)
                          Else
                           JSONParam.AsString  := tmp;
                         End;
                       End;
                     End;
                    DWParams.Add(JSONParam);
                   End;
                 End;
               End;
               vParamList.Free;
             End;
            If vContentStringStream <> Nil Then
             FreeAndNil(vContentStringStream);
           End;
          If DWParams <> Nil Then
           If DWParams.ItemsString['dwEventNameData'] <> Nil Then
            UrlMethod := DWParams.ItemsString['dwEventNameData'].Value;
         End;
       End;
      tmp               := '';
      WelcomeAccept     := True;
      If DWParams.ItemsString['dwwelcomemessage'] <> Nil Then
       vWelcomeMessage := DecodeStrings(DWParams.ItemsString['dwwelcomemessage'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
      If (DWParams.ItemsString['dwaccesstag'] <> Nil) Then
       vAccessTag := DecodeStrings(DWParams.ItemsString['dwaccesstag'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
      If Assigned(vServerMethod) Then
       Begin
        vTempServerMethods := vServerMethod.Create(nil);
        If vServerBaseMethod = TServerMethods Then
         Begin
          TServerMethods(vTempServerMethods).SetClientWelcomeMessage(vWelcomeMessage);
          If Assigned(TServerMethods(vTempServerMethods).OnWelcomeMessage) then
           TServerMethods(vTempServerMethods).OnWelcomeMessage(vWelcomeMessage, vAccessTag, vdwConnectionDefs, WelcomeAccept, vContentType, vErrorMessage);
         End
        Else If vServerBaseMethod = TServerMethodDatamodule Then
         Begin
          TServerMethodDatamodule(vTempServerMethods).SetClientWelcomeMessage(vWelcomeMessage);
          If ARequest.Referer = 'ipv6' Then
           vIPVersion := 'ipv6';
          TServerMethodDatamodule(vTempServerMethods).SetClientInfo(ARequest.RemoteAddr,
                                                                    vIPVersion,
                                                                    ARequest.UserAgent,
                                                                    0);
          If Assigned(TServerMethodDatamodule(vTempServerMethods).OnWelcomeMessage) then
           TServerMethodDatamodule(vTempServerMethods).OnWelcomeMessage(vWelcomeMessage, vAccessTag, vdwConnectionDefs, WelcomeAccept, vContentType, vErrorMessage);
         End;
       End
      Else
       JSONStr := GetPairJSON(-5, 'Server Methods Cannot Assigned');
      Try
       If Assigned(vServerMethod) Then
        Begin
         {$IFNDEF FPC}
         If ARequest.PathInfo + ARequest.Query <> '' Then
         {$ELSE}
         If {$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequest.URI{$ENDIF} <> '' Then
         {$ENDIF}
          Begin
           vOldMethod := UrlMethod;
           If ARequest.Query <> '' Then
            UrlMethod := Trim(ARequest.PathInfo + '?' + ARequest.Query) //Altera��es enviadas por "joaoantonio19"
           Else
            UrlMethod := Trim(ARequest.PathInfo);
           If Pos('/?', UrlMethod) > InitStrPos Then
            UrlMethod := vOldMethod;
          End;
         While (Length(UrlMethod) > 0) Do
          Begin
           If Pos('/', UrlMethod) > 0 then
            Delete(UrlMethod, 1, 1)
           Else
            Begin
             UrlMethod := Trim(UrlMethod);
             If Pos('?', UrlMethod) > 0 Then
              UrlMethod := Copy(UrlMethod, 1, Pos('?', UrlMethod)-1);
             Break;
            End;
          End;
         If (UrlMethod = '') And (urlContext = '') Then
          UrlMethod := vOldMethod;
         If VEncondig = esUtf8 Then
          AResponse.ContentType            := 'application/json;charset=utf-8'
         Else If VEncondig in [esANSI, esASCII] Then
          AResponse.ContentType            := 'application/json;charset=ansi';
         If vTempServerMethods <> Nil Then
          Begin
           JSONStr := ARequest.RemoteAddr;
           If DWParams <> Nil Then
            Begin
             If DWParams.ItemsString['dwassyncexec'] <> Nil Then
              dwassyncexec := DWParams.ItemsString['dwassyncexec'].AsBoolean;
             If DWParams.ItemsString['dwusecript'] <> Nil Then
              vdwCriptKey  := DWParams.ItemsString['dwusecript'].AsBoolean;
            End;
           If dwassyncexec Then
            Begin
             vErrorCode                   := 200;
             {$IFNDEF FPC}
              AResponse.StatusCode        := vErrorCode;
             {$ELSE}
              AResponse.Code              := vErrorCode;
             {$ENDIF}
             If VEncondig = esUtf8 Then
              AResponse.ContentEncoding   := 'utf-8'
             Else
              AResponse.ContentEncoding   := 'ansi';
             AResponse.ContentLength      := -1; //Length(JSONStr);
             If compresseddata Then
              Begin
               If vBinaryEvent Then
                Begin
                 ms := TStringStream.Create('');
                 Try
                  DWParams.SaveToStream(ms, tdwpxt_OUT);
                  ZCompressStreamD(ms, mb2);
                  //SaveLog('Com Compressao');
                 Finally
                  FreeAndNil(ms);
                 End;
                End
               Else
                Begin
                 mb2          := ZCompressStreamNew(AssyncCommandMSG);
                 mb2.Position := 0;
                End;
              End
             Else
              Begin
               If vBinaryEvent Then
                Begin
                 mb := TStringStream.Create('');
                 Try
                  //SaveLog('Sem Compressao');
                  DWParams.SaveToStream(mb, tdwpxt_OUT);
                 Finally

                 End;
                End
               Else
                Begin
                 //SaveLog('Else da Resposta');
                 {$IFDEF FPC}
                  If VEncondig = esUtf8 Then
                   mb                             := TStringStream.Create(Utf8Encode(vReplyStringResult))
                  Else
                   mb                             := TStringStream.Create(vReplyStringResult);
                 {$ELSE}
                 mb                               := TStringStream.Create(vReplyStringResult{$IFNDEF FPC}{$IF CompilerVersion > 21}, TEncoding.UTF8{$IFEND}{$ENDIF});
                 {$ENDIF}
                End;
               mb.Position                      := 0;
              End;
             If Assigned(mb) Then
              FreeAndNil(mb); // Ico Menezes (retirada de Leaks) 05/02/2020
             {$IFNDEF FPC}
              {$IF CompilerVersion > 21}
               AResponse.FreeContentStream      := True;
              {$IFEND}
             {$ELSE}
              AResponse.FreeContentStream       := True;
             {$ENDIF}
             If compresseddata Then
              AResponse.ContentStream           := mb2
             Else
              AResponse.ContentStream           := mb;
             AResponse.ContentStream.Position   := 0;
             AResponse.ContentLength            := AResponse.ContentStream.Size;
             {$IFNDEF FPC}
              AResponse.StatusCode              := vErrorCode;
             {$ELSE}
              AResponse.Code                    := vErrorCode;
             {$ENDIF}
             Handled := True;
            End;
           {$IFDEF FPC}
           If UrlMethod = '' Then
            UrlMethod := StringReplace(ARequest.PathInfo, '/', '', [rfReplaceAll]);
           {$ENDIF}
//           SaveLog; //For Debbug Vars
           If DWParams.itemsstring['binaryRequest'] <> Nil Then
            vBinaryEvent := DWParams.itemsstring['binaryRequest'].value;
           If DWParams.itemsstring['BinaryCompatibleMode'] <> Nil Then
            vBinaryCompatibleMode := DWParams.itemsstring['BinaryCompatibleMode'].Value;
           If DWParams.itemsstring['MetadataRequest'] <> Nil Then
            vMetadata := DWParams.itemsstring['MetadataRequest'].value;
           If Assigned(DWParams) Then
            DWParams.SetCriptOptions(vdwCriptKey, vCripto.Key);
           If DWParams.ItemsString['dwservereventname'] <> Nil Then
            Begin
             If (DWParams.ItemsString['dwservereventname'].AsString <> '') And (Trim(urlContext) = '') Then
              urlContext := DWParams.ItemsString['dwservereventname'].AsString;
            End
           Else
            Begin
             If (UrlMethod <> '') and (urlContext = '') Then
              Begin
               {$IFDEF FPC}
                If Trim(ARequest.Query) <> '' Then
                 TServerUtils.ParseRESTURL (ARequest.PathInfo + '?' + ARequest.Query, VEncondig, UrlMethod, urlContext, vmark{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}, DWParams)
                Else
                 TServerUtils.ParseRESTURL (ARequest.PathInfo, VEncondig, UrlMethod, urlContext, vmark{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}, DWParams);
               {$ELSE}
                If Trim(ARequest.Query) <> '' Then
                 TServerUtils.ParseRESTURL (ARequest.PathInfo + '?' + ARequest.Query, VEncondig, UrlMethod, urlContext, vmark, DWParams)
                Else
                 TServerUtils.ParseRESTURL (ARequest.PathInfo, VEncondig, UrlMethod, urlContext, vmark, DWParams);
               {$ENDIF}
              End;
            End;
//           SaveLog('New Line');
           {$IFDEF FPC}
           If Not ServiceMethods(TComponent(vTempServerMethods), ARequest.LocalPathPrefix, UrlMethod, urlContext, DWParams, JSONStr, JSONMode, vErrorCode,
                                 vContentType, vServerContextCall, ServerContextStream, vdwConnectionDefs, encodestrings, vAccessTag, WelcomeAccept, RequestType, vMark, vRequestHeader, vBinaryEvent, vMetadata, vBinaryCompatibleMode) Then
           {$ELSE}
           If Not ServiceMethods(TComponent(vTempServerMethods), ARequest.Method, UrlMethod, urlContext, DWParams, JSONStr, JsonMode, vErrorCode,
                                 vContentType, vServerContextCall, ServerContextStream, vdwConnectionDefs, encodestrings, vAccessTag, WelcomeAccept, RequestType, vMark, vRequestHeader, vBinaryEvent, vMetadata, vBinaryCompatibleMode) Then
           {$ENDIF}
            Begin
             If Not dwassyncexec Then
              Begin
               If Trim(lowercase(ARequest.PathInfo)) <> '' Then
                sFile := GetFileOSDir(ExcludeTag(Trim(lowercase(ARequest.PathInfo))))
               Else
                sFile := GetFileOSDir(ExcludeTag(Cmd));
               vFileExists := DWFileExists(sFile, FRootPath);
               If Not vFileExists Then
                Begin
                 tmp := '';
                 If ARequest.Referer <> '' Then
                  tmp := GetLastMethod(ARequest.Referer);
                 If Trim(lowercase(ARequest.PathInfo)) <> '' Then
                  sFile := GetFileOSDir(ExcludeTag(tmp + Trim(lowercase(ARequest.PathInfo))))
                 Else
                  sFile := GetFileOSDir(ExcludeTag(Cmd));
                 vFileExists := DWFileExists(sFile, FRootPath);
                End;
               vTagReply := vFileExists or scripttags(ExcludeTag(Cmd));
  //               SaveLog;
               If vTagReply Then
                Begin
                 AResponse.ContentType := GetMIMEType(sFile);
                 If TEncodeSelect(VEncondig) = esUtf8 Then
                  AResponse.ContentEncoding := 'utf-8'
                 Else If TEncodeSelect(VEncondig) in [esANSI, esASCII] Then
                  AResponse.ContentEncoding := 'ansi';
                 If scripttags(ExcludeTag(Cmd)) and Not vFileExists Then
                  AResponse.ContentStream         := TMemoryStream.Create
                 Else
                  AResponse.ContentStream         := TIdReadFileExclusiveStream.Create(sFile);
                 {$IFNDEF FPC}{$if CompilerVersion > 21}AResponse.FreeContentStream := true;{$IFEND}{$ENDIF}
                 {$IFNDEF FPC}
                  AResponse.StatusCode      := 200;
                 {$ELSE}
                  AResponse.Code            := 200;
                 {$ENDIF}
                 Handled := True;
                End;
              End;
            End;
          End;
        End;
       Try
        If Not dwassyncexec Then
         Begin
          If (Not (vTagReply)) Then
           Begin
//            savelog;
            If VEncondig = esUtf8 Then
             AResponse.ContentEncoding := 'utf-8'
            Else
             AResponse.ContentEncoding := 'ansi';
            If vContentType <> '' Then
             AResponse.ContentType := vContentType;
            If Not vServerContextCall Then
             Begin
              If (Assigned(DWParams)) And (UrlMethod <> '') Then
               Begin
                If JsonMode in [jmDataware, jmUndefined] Then
                 Begin
                  If (Trim(JSONStr) <> '') And (Not (vBinaryEvent)) Then
                   Begin
                    If Not(((Pos('{', JSONStr) > 0)   And
                            (Pos('}', JSONStr) > 0))  Or
                           ((Pos('[', JSONStr) > 0)   And
                            (Pos(']', JSONStr) > 0))) Then
                     Begin
                      If Not (WelcomeAccept) And (vErrorMessage <> '') Then
                       JSONStr := vErrorMessage
                      Else If Not((JSONStr[InitStrPos] = '"') And
                             (JSONStr[Length(JSONStr)] = '"')) Then
                       JSONStr := '"' + JSONStr + '"';
                     End;
                   End;
                  If vBinaryEvent Then
                   Begin
                    vReplyString := JSONStr;
                    vErrorCode   := 200;
                   End
                  Else
                   Begin
                    If Not (WelcomeAccept) And (vErrorMessage <> '') Then
                     vReplyString := vErrorMessage
                    Else
                     vReplyString := Format(TValueDisp, [GetParamsReturn(DWParams), JSONStr]);
                   End;
                 End
                Else If JsonMode = jmPureJSON Then
                 Begin
                  If (Trim(JSONStr) = '') And (WelcomeAccept) Then
                   vReplyString := '{}'
                  Else If Not (WelcomeAccept) And (vErrorMessage <> '') Then
                   vReplyString := vErrorMessage
                  Else
                   vReplyString := JSONStr;
                 End;
               End;
              //SaveLog(DWParams.ToJSON);
              If compresseddata Then
               Begin
                If vBinaryEvent Then
                 Begin
                  //SaveLog('BinaryEvent');
                  ms := TStringStream.Create('');
                  Try
                   DWParams.SaveToStream(ms, tdwpxt_OUT);
                   //SaveLog(ms.DataString);
                   ZCompressStreamD(ms, mb2);
                  Finally
                   FreeAndNil(ms);
                  End;
                 End
                Else
                 Begin
                  //SaveLog('No BinaryEvent');
                  mb2 := ZCompressStreamNew(vReplyString);
                 End;
                If Assigned(mb2) Then
                 mb2.Position := 0;
               End
              Else
               Begin
                If (UrlMethod = '') and (urlContext = '') And (vErrorCode = 404) then
                 Begin
                  If vDefaultPage.Count > 0 Then
                   vReplyString                    := vDefaultPage.Text
                  Else
                   vReplyString                    := TServerStatusHTML;
                  vErrorCode                       := 200;
                  AResponse.ContentType            := 'text/html';
                 End;
                 If (vBinaryEvent) And (Assigned(DWParams)) Then
                  Begin
                   mb := TStringStream.Create('');
                   Try
                    DWParams.SaveToStream(mb, tdwpxt_OUT);
                   Finally
                   End;
                  End
                 Else
                  Begin
                   {$IFDEF FPC}
                    If VEncondig = esUtf8 Then
                     mb                               := TStringStream.Create(Utf8Encode(vReplyString))
                    Else
                     mb                               := TStringStream.Create(vReplyString);
                   {$ELSE}
                    mb                                := TStringStream.Create(vReplyString{$IFNDEF FPC}{$IF CompilerVersion > 21}, TEncoding.UTF8{$IFEND}{$ENDIF});
                   {$ENDIF}
                  End;
                 mb.Position                        := 0;
               End;
              If vErrorCode <> 200 Then
               Begin
                If Assigned(mb2) Then
                 FreeAndNil(mb2);
                If Assigned(mb) Then
                 FreeAndNil(mb);
                {$IFNDEF FPC}
                AResponse.ReasonString           := aEncodeStrings(vReplyString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
                {$ELSE}
                AResponse.CodeText               := aEncodeStrings(vReplyString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
                {$ENDIF}
               End
              Else
               Begin
                {$IFNDEF FPC}
                {$IF CompilerVersion > 21}
                AResponse.FreeContentStream      := True;
                {$IFEND}
                {$ELSE}
                 AResponse.FreeContentStream     := True;
                {$ENDIF}
                //SaveLog('New Data');
                If compresseddata Then
                 AResponse.ContentStream         := mb2
                Else
                 AResponse.ContentStream         := mb;
                AResponse.ContentStream.Position := 0;
                AResponse.ContentLength          := AResponse.ContentStream.Size;
               End;
              {$IFNDEF FPC}
               AResponse.StatusCode            := vErrorCode;
              {$ELSE}
               AResponse.Code                  := vErrorCode;
              {$ENDIF}
              //SaveLog(DWParams.ToJSON);
             End
            Else
             Begin
              {$IFNDEF FPC}
               AResponse.StatusCode            := vErrorCode;
              {$ELSE}
               AResponse.Code                  := vErrorCode;
              {$ENDIF}
              If TEncodeSelect(VEncondig) = esUtf8 Then
               AResponse.ContentEncoding := 'utf-8'
              Else If TEncodeSelect(VEncondig) in [esANSI, esASCII] Then
               AResponse.ContentEncoding := 'ansi';
              If vBinaryEvent Then
               Begin
                If compresseddata Then
                 AResponse.ContentStream         := mb2
                Else
                 AResponse.ContentStream         := mb;
                AResponse.ContentStream.Position := 0;
                AResponse.ContentLength          := AResponse.ContentStream.Size;
                {$IFNDEF FPC}
                 AResponse.StatusCode            := vErrorCode;
                {$ELSE}
                 AResponse.Code                  := vErrorCode;
                {$ENDIF}
               End
              Else If ServerContextStream <> Nil Then
               Begin
                {$IFNDEF FPC}{$if CompilerVersion > 21}AResponse.FreeContentStream := true;{$IFEND}{$ENDIF}
                ServerContextStream.Position := 0;
                AResponse.ContentStream      := ServerContextStream;
                AResponse.ContentLength      := ServerContextStream.Size;
               End
              Else
               Begin
                AResponse.ContentLength      := -1; //Length(JSONStr);
                {$IFDEF FPC}
                 If VEncondig = esUtf8 Then
                  AResponse.Content          := Utf8Encode(JSONStr)
                 Else
                AResponse.Content            := JSONStr;
                {$ELSE}
                 AResponse.Content           := JSONStr;
                {$ENDIF}
               End;
             End;
           End;
         End;
       Finally
        {$IFNDEF FPC}
        {$IF CompilerVersion < 21}
        If Assigned(mb) Then
         FreeAndNil(mb);
        If Assigned(mb2) Then
         FreeAndNil(mb2);
        If Assigned(ServerContextStream) Then
         FreeAndNil(ServerContextStream);
        {$IFEND}
        {$ENDIF}
       End;
      Finally
       If Assigned(vServerMethod) Then
        If Assigned(vTempServerMethods) Then
         Begin
          Try
           FreeAndNil(vTempServerMethods); //.free;
          Except
          End;
         End;
      End;
     End;
 Finally
  //SaveLog('OnFinally');
  If AResponse.ContentLength = 0 Then
   Begin
   If vDefaultPage.Count > 0 Then
    vReplyString                    := vDefaultPage.Text
    Else
    vReplyString                    := TServerStatusHTML;
    AResponse.Content := vReplyString;
   End;
  If Not dwassyncexec Then
   Handled := True;
  //SaveLog(DWParams.ToJSON);
  If Assigned(DWParams) Then
   FreeAndNil(DWParams);
  If Assigned(vdwConnectionDefs) Then
   FreeAndNil(vdwConnectionDefs);
  If Assigned(vRequestHeader) then
   FreeAndNil(vRequestHeader);
 End;
End;

Procedure TRESTServiceCGI.SetCORSCustomHeader (Value : TStringList);
Var
 I : Integer;
Begin
 vCORSCustomHeaders.Clear;
 For I := 0 To Value.Count -1 do
  vCORSCustomHeaders.Add(Value[I]);
End;

Procedure TRESTServiceCGI.SetDefaultPage (Value : TStringList);
Var
 I : Integer;
Begin
 vDefaultPage.Clear;
 For I := 0 To Value.Count -1 do
  vDefaultPage.Add(Value[I]);
End;

procedure TRESTServiceCGI.SetRESTServiceNotification(
  Value: TRESTDWServiceNotification);
begin
 If Value <> Nil Then
    vRESTServiceNotification := Value;

 if vRESTServiceNotification <> nil then
   vRESTServiceNotification.FreeNotification(Self);
end;

Procedure TRESTServiceCGI.Loaded;
Begin
 Inherited;
 If Assigned(vOnCreate) Then
  vOnCreate(Self);
End;

procedure TRESTServiceCGI.SetServerMethod(Value: TComponentClass);
begin
 If (Value.ClassParent      = TServerMethods) Or
    (Value                  = TServerMethods) Then
  Begin
   vServerMethod     := Value;
   vServerBaseMethod := TServerMethods;
  End
 Else If (Value.ClassParent = TServerMethodDatamodule) Or
         (Value             = TServerMethodDatamodule) Then
  Begin
   vServerMethod := Value;
   vServerBaseMethod := TServerMethodDatamodule;
  End;
end;

procedure TRESTServiceCGI.GetPoolerList(ServerMethodsClass: TComponent;
                                        Var PoolerList    : String;
                                        AccessTag         : String);
Var
 I : Integer;
Begin
 If ServerMethodsClass <> Nil Then
  Begin
   For I := 0 To ServerMethodsClass.ComponentCount -1 Do
    Begin
     If ServerMethodsClass.Components[i] is TRESTDWPoolerDB Then
      Begin
       If Trim(TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag) <> '' Then
        Begin
         If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag <> AccessTag Then
          Continue;
        End;
       If PoolerList = '' then
        PoolerList := Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name])
       Else
        PoolerList := PoolerList + '|' + Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name]);
      End;
    End;
  End;
End;

Procedure TRESTServiceCGI.GetServerEventsList(ServerMethodsClass   : TComponent;
                                              Var ServerEventsList : String;
                                              AccessTag            : String);
Var
 I : Integer;
Begin
 If ServerMethodsClass <> Nil Then
  Begin
   For I := 0 To ServerMethodsClass.ComponentCount -1 Do
    Begin
     If ServerMethodsClass.Components[i] is TDWServerEvents Then
      Begin
       If Trim(TDWServerEvents(ServerMethodsClass.Components[i]).AccessTag) <> '' Then
        Begin
         If TDWServerEvents(ServerMethodsClass.Components[i]).AccessTag <> AccessTag Then
          Continue;
        End;
       If ServerEventsList = '' then
        ServerEventsList := Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name])
       Else
        ServerEventsList := ServerEventsList + '|' + Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name]);
      End;
    End;
  End;
End;

Function TRESTServiceCGI.ServiceMethods(BaseObject     : TComponent;
                                        AContext,
                                        UrlMethod,
                                        urlContext              : String;
                                        Var DWParams            : TDWParams;
                                        Var JSONStr             : String;
                                        Var JsonMode            : TJsonMode;
                                        Var ErrorCode           : Integer;
                                        Var ContentType         : String;
                                        Var ServerContextCall   : Boolean;
                                        Var ServerContextStream : TMemoryStream;
                                        ConnectionDefs          : TConnectionDefs;
                                        hEncodeStrings          : Boolean;
                                        AccessTag               : String;
                                        WelcomeAccept           : Boolean;
                                        Const RequestType       : TRequestType;
                                        mark                    : String;
                                        Var   RequestHeader     : TStringList;
                                        BinaryEvent             : Boolean;
                                        Metadata                : Boolean;
                                        BinaryCompatibleMode    : Boolean): Boolean;
Var
 vJsonMSG,
 vResult,
 vResultIP,
 vUrlMethod   : String;
 vError,
 vInvalidTag  : Boolean;
 JSONParam    : TJSONParam;
Begin
 Result       := False;
 vUrlMethod   := UpperCase(UrlMethod);
 If WelcomeAccept Then
  Begin
   If vUrlMethod = UpperCase('GetPoolerList') Then
    Begin
     Result     := True;
     GetPoolerList(BaseObject, vResult, AccessTag);
     If DWParams.ItemsString['Result'] = Nil Then
      Begin
       JSONParam                 := TJSONParam.Create(DWParams.Encoding);
       JSONParam.ParamName       := 'Result';
       JSONParam.ObjectDirection := odOut;
       DWParams.Add(JSONParam);
      End;
     DWParams.ItemsString['Result'].SetValue(vResult, DWParams.ItemsString['Result'].Encoded);
     JSONStr    := TReplyOK;
    End
   Else If vUrlMethod = UpperCase('GetServerEventsList') Then
    Begin
     Result     := True;
     GetServerEventsList(BaseObject, vResult, AccessTag);
     If DWParams.ItemsString['Result'] = Nil Then
      Begin
       JSONParam                 := TJSONParam.Create(DWParams.Encoding);
       JSONParam.ParamName       := 'Result';
       JSONParam.ObjectDirection := odOut;
       DWParams.Add(JSONParam);
      End;
     DWParams.ItemsString['Result'].SetValue(vResult,
                                             DWParams.ItemsString['Result'].Encoded);
     JSONStr    := TReplyOK;
    End
   Else If vUrlMethod = UpperCase('EchoPooler') Then
    Begin
     vResultIP := JSONStr;
     vJsonMSG  := TReplyNOK;
     If DWParams.ItemsString['Pooler'] <> Nil Then
      Begin
       vResult    := DWParams.ItemsString['Pooler'].Value;
       EchoPooler(BaseObject, JSONStr, vResult, vResultIP, AccessTag, vInvalidTag);
      End;
     If DWParams.ItemsString['Result'] = Nil Then
      Begin
       JSONParam                 := TJSONParam.Create(DWParams.Encoding);
       JSONParam.ParamName       := 'Result';
       JSONParam.ObjectValue     := ovString;
       JSONParam.ObjectDirection := odOut;
       DWParams.Add(JSONParam);
      End;
     DWParams.ItemsString['Result'].SetValue(vResultIP,
                                             DWParams.ItemsString['Result'].Encoded);
     Result := vResultIP <> '';
     If Result Then
      Begin
       If DWParams.ItemsString['Result'] <> Nil Then
        JSONStr  := TReplyOK
       Else
        JSONStr  := vResultIP;
      End
     Else If vInvalidTag Then
      JSONStr    := TReplyTagError
     Else
      Begin
       JSONStr    := TReplyInvalidPooler;
       ErrorCode  := 405;
      End;
    End
   Else If vUrlMethod = UpperCase('ExecuteCommandPureJSON') Then
    Begin
     vResult    := DWParams.ItemsString['Pooler'].Value;
     ExecuteCommandPureJSON(BaseObject, vResult, DWParams, ConnectionDefs, hEncodeStrings, AccessTag, BinaryEvent, Metadata, BinaryCompatibleMode);
     Result     := True;
     If Not(DWParams.ItemsString['Error'].AsBoolean) Then
      JSONStr    := TReplyOK
     Else
      JSONStr   := TReplyNOK;
    End
   Else If vUrlMethod = UpperCase('ExecuteCommandJSON') Then
    Begin
     vResult    := DWParams.ItemsString['Pooler'].Value;
     ExecuteCommandJSON(BaseObject, vResult, DWParams, ConnectionDefs, hEncodeStrings, AccessTag, BinaryEvent, Metadata, BinaryCompatibleMode);
     Result     := True;
     If Not(DWParams.ItemsString['Error'].AsBoolean) Then
      JSONStr    := TReplyOK
     Else
      JSONStr   := TReplyNOK;
    End
   Else If vUrlMethod = UpperCase('ApplyUpdates') Then
    Begin
     vResult    := DWParams.ItemsString['Pooler'].Value;
     ApplyUpdatesJSON(BaseObject, vResult, DWParams, ConnectionDefs, hEncodeStrings, AccessTag);
     Result     := True;
     If Not(DWParams.ItemsString['Error'].AsBoolean) Then
      JSONStr    := TReplyOK
     Else
      JSONStr   := TReplyNOK;
    End
   Else If vUrlMethod = UpperCase('ApplyUpdates_MassiveCache') Then
    Begin
     vResult    := DWParams.ItemsString['Pooler'].Value;
     ApplyUpdates_MassiveCache(BaseObject, vResult, DWParams, ConnectionDefs, hEncodeStrings, AccessTag);
     Result     := True;
     If Not(DWParams.ItemsString['Error'].AsBoolean) Then
      JSONStr    := TReplyOK
     Else
      JSONStr   := TReplyNOK;
    End
   Else If vUrlMethod = UpperCase('ProcessMassiveSQLCache') Then
    Begin
     vResult    := DWParams.ItemsString['Pooler'].Value;
     ProcessMassiveSQLCache(BaseObject, vResult, DWParams, ConnectionDefs, hEncodeStrings, AccessTag);
     Result     := True;
     If Not(DWParams.ItemsString['Error'].AsBoolean) Then
      JSONStr    := TReplyOK
     Else
      JSONStr   := TReplyNOK;
    End
   Else If vUrlMethod = UpperCase('GetTableNames') Then
    Begin
     vResult    := DWParams.ItemsString['Pooler'].Value;
     GetTableNames(BaseObject, vResult, DWParams, ConnectionDefs, hEncodeStrings, AccessTag);
     Result     := True;
     If Not(DWParams.ItemsString['Error'].AsBoolean) Then
      JSONStr    := TReplyOK
     Else
      JSONStr   := TReplyNOK;
    End
   Else If vUrlMethod = UpperCase('GetFieldNames') Then
    Begin
     vResult    := DWParams.ItemsString['Pooler'].Value;
     GetFieldNames(BaseObject, vResult, DWParams, ConnectionDefs, hEncodeStrings, AccessTag);
     Result     := True;
     If Not(DWParams.ItemsString['Error'].AsBoolean) Then
      JSONStr    := TReplyOK
     Else
      JSONStr   := TReplyNOK;
    End
   Else If vUrlMethod = UpperCase('GetKeyFieldNames') Then
    Begin
     vResult    := DWParams.ItemsString['Pooler'].Value;
     GetKeyFieldNames(BaseObject, vResult, DWParams, ConnectionDefs, hEncodeStrings, AccessTag);
     Result     := True;
     If Not(DWParams.ItemsString['Error'].AsBoolean) Then
      JSONStr    := TReplyOK
     Else
      JSONStr   := TReplyNOK;
    End
   Else If vUrlMethod = UpperCase('InsertMySQLReturnID_PARAMS') Then
    Begin
     vResult    := DWParams.ItemsString['Pooler'].Value;
     InsertMySQLReturnID(BaseObject, vResult, DWParams, ConnectionDefs, hEncodeStrings, AccessTag);
     Result     := True;
     If Not(DWParams.ItemsString['Error'].AsBoolean) Then
      JSONStr    := TReplyOK
     Else
      JSONStr   := TReplyNOK;
    End
   Else If vUrlMethod = UpperCase('InsertMySQLReturnID') Then
    Begin
     vResult    := DWParams.ItemsString['Pooler'].Value;
     InsertMySQLReturnID(BaseObject, vResult, DWParams, ConnectionDefs, hEncodeStrings, AccessTag);
     Result     := True;
     If Not(DWParams.ItemsString['Error'].AsBoolean) Then
      JSONStr    := TReplyOK
     Else
      JSONStr   := TReplyNOK;
    End
   Else If vUrlMethod = UpperCase('OpenDatasets') Then
    Begin
     vResult     := DWParams.ItemsString['Pooler'].Value;
     OpenDatasets(BaseObject, vResult, DWParams, ConnectionDefs, hEncodeStrings, AccessTag, BinaryEvent);
     Result      := True;
     If Not(DWParams.ItemsString['Error'].AsBoolean) Then
      JSONStr    := TReplyOK
     Else
      JSONStr   := TReplyNOK;
    End
   Else If vUrlMethod = UpperCase('GETEVENTS') Then
    Begin
     If DWParams.ItemsString['Error'] = Nil Then
      Begin
       JSONParam                 := TJSONParam.Create(DWParams.Encoding);
       JSONParam.ParamName       := 'Error';
       JSONParam.ObjectDirection := odOut;
       DWParams.Add(JSONParam);
      End;
     If DWParams.ItemsString['MessageError'] = Nil Then
      Begin
       JSONParam                 := TJSONParam.Create(DWParams.Encoding);
       JSONParam.ParamName       := 'MessageError';
       JSONParam.ObjectDirection := odOut;
       DWParams.Add(JSONParam);
      End;
     If DWParams.ItemsString['Result'] = Nil Then
      Begin
       JSONParam                 := TJSONParam.Create(DWParams.Encoding);
       JSONParam.ParamName       := 'Result';
       JSONParam.ObjectDirection := odOut;
       DWParams.Add(JSONParam);
      End;
     GetEvents(BaseObject, vResult, urlContext, DWParams);
     If Not(DWParams.ItemsString['Error'].AsBoolean) Then
      JSONStr    := TReplyOK
     Else
      Begin
       If DWParams.ItemsString['MessageError'] <> Nil Then
        JSONStr   := DWParams.ItemsString['MessageError'].AsString
       Else
        Begin
         JSONStr   := TReplyNOK;
         ErrorCode  := 500;
        End;
      End;
     Result      := JSONStr = TReplyOK;
    End
   Else
    Begin
     If ReturnEvent(BaseObject, vUrlMethod, vResult, urlContext, DWParams, JsonMode, ErrorCode, ContentType, Accesstag, RequestType, RequestHeader) Then
      Begin
       JSONStr := vResult;
       Result  := JSONStr <> '';
      End
     Else
      Begin
       ErrorCode := 200;
       Result  := ReturnContext(BaseObject, vUrlMethod, vResult, urlContext, ContentType, ServerContextStream, vError, DWParams, RequestType, mark, RequestHeader, ErrorCode);
       If Not (Result) Or (vError) Then
        Begin
         If Not WelcomeAccept Then
          Begin
           JsonMode   := jmPureJSON;
           JSONStr    := TReplyInvalidWelcome;
           If (ErrorCode <= 0) Or
              (ErrorCode = 200) Then
            ErrorCode  := 500;
          End
         Else
          Begin
           JsonMode   := jmPureJSON;
           JSONStr    := vResult;
           If (ErrorCode <= 0) Or
              (ErrorCode = 200) Then
            ErrorCode  := 404;
          End;
         If vError Then
          Result := True;
        End
       Else
        Begin
         JsonMode  := jmPureJSON;
         JSONStr   := vResult;
         If (ErrorCode <= 0) Or
            (ErrorCode > 299) Then
          ErrorCode := 200;
         ServerContextCall := True;
        End;
      End;
    End;
  End
 Else If (vUrlMethod = UpperCase('GETEVENTS')) And (Not (vForceWelcomeAccess)) Then
  Begin
   If DWParams.ItemsString['Error'] = Nil Then
    Begin
     JSONParam                 := TJSONParam.Create(DWParams.Encoding);
     JSONParam.ParamName       := 'Error';
     JSONParam.ObjectDirection := odOut;
     DWParams.Add(JSONParam);
    End;
   If DWParams.ItemsString['MessageError'] = Nil Then
    Begin
     JSONParam                 := TJSONParam.Create(DWParams.Encoding);
     JSONParam.ParamName       := 'MessageError';
     JSONParam.ObjectDirection := odOut;
     DWParams.Add(JSONParam);
    End;
   If DWParams.ItemsString['Result'] = Nil Then
    Begin
     JSONParam                 := TJSONParam.Create(DWParams.Encoding);
     JSONParam.ParamName       := 'Result';
     JSONParam.ObjectDirection := odOut;
     DWParams.Add(JSONParam);
    End;
   GetEvents(BaseObject, vResult, urlContext, DWParams);
   If Not(DWParams.ItemsString['Error'].AsBoolean) Then
    JSONStr    := TReplyOK
   Else
    Begin
     If DWParams.ItemsString['MessageError'] <> Nil Then
      JSONStr   := DWParams.ItemsString['MessageError'].AsString
     Else
      Begin
       JSONStr   := TReplyNOK;
       ErrorCode  := 500;
      End;
    End;
   Result      := JSONStr = TReplyOK;
  End
 Else If (Not (vForceWelcomeAccess)) Then
  Begin
   If Not WelcomeAccept Then
    JSONStr := TReplyInvalidWelcome
   Else
    Begin
     If ReturnEvent(BaseObject, vUrlMethod, vResult, urlContext, DWParams, JsonMode, ErrorCode, ContentType, Accesstag, RequestType, RequestHeader) Then
      Begin
       JSONStr := vResult;
       Result  := JSONStr <> '';
      End
     Else
      Begin
       If Not WelcomeAccept Then
        Begin
         JSONStr   := TReplyInvalidWelcome;
         ErrorCode := 500;
        End
       Else
        JSONStr := '';
       Result  := JSONStr <> '';
      End;
    End;
  End
 Else
  Begin
   If Not WelcomeAccept Then
    JSONStr := TReplyInvalidWelcome
   Else
    JSONStr := TReplyNOK;
   Result  := False;
   If DWParams.ItemsString['Error']        <> Nil Then
    DWParams.ItemsString['Error'].AsBoolean := True;
   If DWParams.ItemsString['MessageError'] <> Nil Then
    DWParams.ItemsString['MessageError'].AsString := 'Invalid welcomemessage...'
   Else
    ErrorCode  := 500;
  End;
End;

procedure TRESTServiceCGI.EchoPooler(ServerMethodsClass : TComponent;
                                     AContext           : String;
                                     Var Pooler, MyIP   : String;
                                     AccessTag          : String;
                                     Var InvalidTag     : Boolean);
Var
 I : Integer;
Begin
 MyIP := '';
 InvalidTag := False;
 If ServerMethodsClass <> Nil Then
  Begin
   For I := 0 To ServerMethodsClass.ComponentCount -1 Do
    Begin
     If ServerMethodsClass.Components[i] is TRESTDWPoolerDB Then
      Begin
       If Pooler = Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name]) Then
        Begin
         If Trim(TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag) <> '' Then
          Begin
           If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag <> AccessTag Then
            Begin
             InvalidTag := True;
             Exit;
            End;
          End;
         If AContext <> '' Then
          MyIP := AContext;
         Break;
        End;
      End;
    End;
  End;
End;

Procedure TRESTServiceCGI.GetTableNames(ServerMethodsClass   : TComponent;
                                        Var Pooler           : String;
                                        Var DWParams         : TDWParams;
                                        ConnectionDefs       : TConnectionDefs;
                                        hEncodeStrings       : Boolean;
                                        AccessTag            : String);
Var
 I             : Integer;
 vError        : Boolean;
 vMessageError : String;
 vStrings      : TStringList;
Begin
 If ServerMethodsClass <> Nil Then
  Begin
   For I := 0 To ServerMethodsClass.ComponentCount -1 Do
    Begin
     If ServerMethodsClass.Components[i] is TRESTDWPoolerDB Then
      Begin
       If UpperCase(Pooler) = UpperCase(Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name])) then
        Begin
         If Trim(TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag) <> '' Then
          Begin
           If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag <> AccessTag Then
            Begin
             DWParams.ItemsString['MessageError'].AsString := 'Invalid Access tag...';
             DWParams.ItemsString['Error'].AsBoolean       := True;
             Exit;
            End;
          End;
         If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver <> Nil Then
          Begin
           vError   := DWParams.ItemsString['Error'].AsBoolean;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.Encoding          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).Encoding;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.EncodeStringsJSON := hEncodeStrings;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsEmpty2Null    := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsEmpty2Null;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim2Len      := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim2Len;
//           vStrings := TStringList.Create;
           Try
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.PrepareConnection(ConnectionDefs);
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.GetTableNames(vStrings, vError, vMessageError);
            If DWParams.ItemsString['Result'] <> Nil Then
             Begin
              DWParams.ItemsString['Result'].CriptOptions.Use := False;
              DWParams.ItemsString['Result'].SetValue(vStrings.Text, DWParams.ItemsString['Result'].Encoded);
             End;
           Except
            On E : Exception Do
             Begin
              vMessageError := e.Message;
              vError := True;
             End;
           End;
           FreeAndNil(vStrings);
           If vMessageError <> '' Then
            Begin
             DWParams.ItemsString['MessageError'].CriptOptions.Use := False;
             DWParams.ItemsString['MessageError'].AsString := EncodeStrings(vMessageError{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
            End;
           DWParams.ItemsString['Error'].AsBoolean := vError;
          End;
         Break;
        End;
      End;
    End;
  End;
End;

Procedure TRESTServiceCGI.GetKeyFieldNames(ServerMethodsClass   : TComponent;
                                           Var Pooler           : String;
                                           Var DWParams         : TDWParams;
                                           ConnectionDefs       : TConnectionDefs;
                                           hEncodeStrings       : Boolean;
                                           AccessTag            : String);
Var
 I             : Integer;
 vError        : Boolean;
 vTableName,
 vMessageError : String;
 vStrings      : TStringList;
Begin
 If ServerMethodsClass <> Nil Then
  Begin
   For I := 0 To ServerMethodsClass.ComponentCount -1 Do
    Begin
     If ServerMethodsClass.Components[i] is TRESTDWPoolerDB Then
      Begin
       If UpperCase(Pooler) = UpperCase(Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name])) then
        Begin
         If Trim(TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag) <> '' Then
          Begin
           If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag <> AccessTag Then
            Begin
             DWParams.ItemsString['MessageError'].AsString := 'Invalid Access tag...';
             DWParams.ItemsString['Error'].AsBoolean       := True;
             Exit;
            End;
          End;
         If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver <> Nil Then
          Begin
           vError   := DWParams.ItemsString['Error'].AsBoolean;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.Encoding          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).Encoding;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.EncodeStringsJSON := hEncodeStrings;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsEmpty2Null    := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsEmpty2Null;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim2Len      := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim2Len;
//           vStrings := TStringList.Create;
           Try
            DWParams.ItemsString['TableName'].CriptOptions.Use := False;
            vTableName := DWParams.ItemsString['TableName'].AsString;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.PrepareConnection(ConnectionDefs);
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.GetKeyFieldNames(vTableName, vStrings, vError, vMessageError);
            If DWParams.ItemsString['Result'] <> Nil Then
             Begin
              DWParams.ItemsString['Result'].CriptOptions.Use := False;
              DWParams.ItemsString['Result'].SetValue(vStrings.Text, DWParams.ItemsString['Result'].Encoded);
             End;
           Except
            On E : Exception Do
             Begin
              vMessageError := e.Message;
              vError := True;
             End;
           End;
           FreeAndNil(vStrings);
           If vMessageError <> '' Then
            Begin
             DWParams.ItemsString['MessageError'].CriptOptions.Use := False;
             DWParams.ItemsString['MessageError'].AsString := EncodeStrings(vMessageError{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
            End;
           DWParams.ItemsString['Error'].AsBoolean := vError;
          End;
         Break;
        End;
      End;
    End;
  End;
End;

Procedure TRESTServiceCGI.GetFieldNames(ServerMethodsClass   : TComponent;
                                        Var Pooler           : String;
                                        Var DWParams         : TDWParams;
                                        ConnectionDefs       : TConnectionDefs;
                                        hEncodeStrings       : Boolean;
                                        AccessTag            : String);
Var
 I             : Integer;
 vError        : Boolean;
 vTableName,
 vMessageError : String;
 vStrings      : TStringList;
Begin
 If ServerMethodsClass <> Nil Then
  Begin
   For I := 0 To ServerMethodsClass.ComponentCount -1 Do
    Begin
     If ServerMethodsClass.Components[i] is TRESTDWPoolerDB Then
      Begin
       If UpperCase(Pooler) = UpperCase(Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name])) then
        Begin
         If Trim(TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag) <> '' Then
          Begin
           If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag <> AccessTag Then
            Begin
             DWParams.ItemsString['MessageError'].AsString := 'Invalid Access tag...';
             DWParams.ItemsString['Error'].AsBoolean       := True;
             Exit;
            End;
          End;
         If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver <> Nil Then
          Begin
           vError   := DWParams.ItemsString['Error'].AsBoolean;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.Encoding          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).Encoding;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.EncodeStringsJSON := hEncodeStrings;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsEmpty2Null    := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsEmpty2Null;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim2Len      := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim2Len;
//           vStrings := TStringList.Create;
           Try
            DWParams.ItemsString['TableName'].CriptOptions.Use := False;
            vTableName := DWParams.ItemsString['TableName'].AsString;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.PrepareConnection(ConnectionDefs);
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.GetFieldNames(vTableName, vStrings, vError, vMessageError);
            If DWParams.ItemsString['Result'] <> Nil Then
             Begin
              DWParams.ItemsString['Result'].CriptOptions.Use := False;
              DWParams.ItemsString['Result'].SetValue(vStrings.Text, DWParams.ItemsString['Result'].Encoded);
             End;
           Except
            On E : Exception Do
             Begin
              vMessageError := e.Message;
              vError := True;
             End;
           End;
           FreeAndNil(vStrings);
           If vMessageError <> '' Then
            Begin
             DWParams.ItemsString['MessageError'].CriptOptions.Use := False;
             DWParams.ItemsString['MessageError'].AsString := EncodeStrings(vMessageError{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
            End;
           DWParams.ItemsString['Error'].AsBoolean := vError;
          End;
         Break;
        End;
      End;
    End;
  End;
End;

procedure TRESTServiceCGI.ExecuteCommandPureJSON(ServerMethodsClass   : TComponent;
                                                 Var Pooler           : String;
                                                 Var DWParams         : TDWParams;
                                                 ConnectionDefs       : TConnectionDefs;
                                                 hEncodeStrings       : Boolean;
                                                 AccessTag            : String;
                                                 BinaryEvent          : Boolean;
                                                 Metadata             : Boolean;
                                                 BinaryCompatibleMode : Boolean);
Var
 vRowsAffected,
 I             : Integer;
 vEncoded,
 vError,
 vExecute      : Boolean;
 vTempJSON,
 vMessageError : String;
 BinaryBlob    : TMemoryStream;
Begin
 BinaryBlob    := Nil;
 vRowsAffected := 0;
  try
   If ServerMethodsClass <> Nil Then
    Begin
     For I := 0 To ServerMethodsClass.ComponentCount -1 Do
      Begin
       If ServerMethodsClass.Components[i] is TRESTDWPoolerDB Then
        Begin
         If UpperCase(Pooler) = UpperCase(Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name])) then
          Begin
           If Trim(TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag) <> '' Then
            Begin
             If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag <> AccessTag Then
              Begin
               DWParams.ItemsString['MessageError'].AsString := 'Invalid Access tag...';
               DWParams.ItemsString['Error'].AsBoolean       := True;
               Exit;
              End;
            End;
           If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver <> Nil Then
            Begin
             vExecute := DWParams.ItemsString['Execute'].AsBoolean;
             vError   := DWParams.ItemsString['Error'].AsBoolean;
             TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.Encoding          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).Encoding;
             TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.EncodeStringsJSON := hEncodeStrings;
             TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim;
             TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsEmpty2Null    := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsEmpty2Null;
             TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim2Len      := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim2Len;
             Try
              TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.PrepareConnection(ConnectionDefs);
              vTempJSON := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.ExecuteCommand(DWParams.ItemsString['SQL'].Value,
                                                                                                       vError,
                                                                                                       vMessageError,
                                                                                                       BinaryBlob,
                                                                                                       vRowsAffected,
                                                                                                       vExecute, BinaryEvent, Metadata, BinaryCompatibleMode);
             Except
              On E : Exception Do
               Begin
                vMessageError := e.Message;
                vError := True;
               End;
             End;
             If vMessageError <> '' Then
              Begin
               DWParams.ItemsString['MessageError'].CriptOptions.Use := False;
               DWParams.ItemsString['MessageError'].AsString := EncodeStrings(vMessageError{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
              End;
             DWParams.ItemsString['Error'].AsBoolean := vError;
             If DWParams.ItemsString['RowsAffected'] <> Nil Then
              DWParams.ItemsString['RowsAffected'].AsInteger := vRowsAffected;
             If DWParams.ItemsString['Result'] <> Nil Then
              Begin
               vEncoded := DWParams.ItemsString['Result'].Encoded;
               If (BinaryEvent) And (Not (vError)) Then
                DWParams.ItemsString['Result'].LoadFromStream(BinaryBlob)
               Else If Not(vError) And (vTempJSON <> '') Then
                DWParams.ItemsString['Result'].SetValue(vTempJSON, vEncoded)
               Else
                DWParams.ItemsString['Result'].SetValue('');
              End;
            End;
           Break;
          End;
        End;
      End;
    End;
  Finally
   if Assigned(BinaryBlob) then
    FreeAndNil(BinaryBlob);
  End;
End;

procedure TRESTServiceCGI.ExecuteCommandJSON(ServerMethodsClass   : TComponent;
                                             Var Pooler           : String;
                                             Var DWParams         : TDWParams;
                                             ConnectionDefs       : TConnectionDefs;
                                             hEncodeStrings       : Boolean;
                                             AccessTag            : String;
                                             BinaryEvent          : Boolean;
                                             Metadata             : Boolean;
                                             BinaryCompatibleMode : Boolean);
Var
 vRowsAffected,
 I             : Integer;
 vError,
 vExecute      : Boolean;
 vTempJSON,
 vMessageError : String;
 DWParamsD     : TDWParams;
 BinaryBlob    : TMemoryStream;
Begin
 DWParamsD     := Nil;
 BinaryBlob    := Nil;
 vRowsAffected := 0;
 Try
  If ServerMethodsClass <> Nil Then
   Begin
    For I := 0 To ServerMethodsClass.ComponentCount -1 Do
     Begin
      If ServerMethodsClass.Components[i] is TRESTDWPoolerDB Then
       Begin
        If UpperCase(Pooler) = UpperCase(Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name])) then
         Begin
          If Trim(TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag) <> '' Then
           Begin
            If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag <> AccessTag Then
             Begin
              DWParams.ItemsString['MessageError'].AsString := 'Invalid Access tag...';
              DWParams.ItemsString['Error'].AsBoolean       := True;
              Exit;
             End;
           End;
          If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver <> Nil Then
           Begin
            vExecute := DWParams.ItemsString['Execute'].AsBoolean;
            vError   := DWParams.ItemsString['Error'].AsBoolean;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.Encoding          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).Encoding;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.EncodeStringsJSON := hEncodeStrings;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsEmpty2Null    := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsEmpty2Null;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim2Len      := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim2Len;
            If DWParams.ItemsString['Params'] <> Nil Then
             Begin
              DWParamsD := TDWParams.Create;
              DWParamsD.FromJSON(DWParams.ItemsString['Params'].Value);
             End;
            Try
             TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.PrepareConnection(ConnectionDefs);
             If DWParamsD <> Nil Then
              Begin
               vTempJSON := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.ExecuteCommand(DWParams.ItemsString['SQL'].Value,
                                                                                                        DWParamsD, vError, vMessageError,
                                                                                                        BinaryBlob, vRowsAffected,
                                                                                                        vExecute, BinaryEvent, Metadata, BinaryCompatibleMode);
              End
             Else
              vTempJSON := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.ExecuteCommand(DWParams.ItemsString['SQL'].Value,
                                                                                                       vError,
                                                                                                       vMessageError,
                                                                                                       BinaryBlob, vRowsAffected,
                                                                                                       vExecute, BinaryEvent, Metadata, BinaryCompatibleMode);
            Except
             On E : Exception Do
              Begin
               vMessageError := e.Message;
               vError := True;
              End;
            End;
            If vMessageError <> '' Then
             Begin
              DWParams.ItemsString['MessageError'].CriptOptions.Use := False;
              DWParams.ItemsString['MessageError'].AsString := EncodeStrings(vMessageError{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
             End;
            DWParams.ItemsString['Error'].AsBoolean        := vError;
            If DWParams.ItemsString['RowsAffected'] <> Nil Then
             DWParams.ItemsString['RowsAffected'].AsInteger := vRowsAffected;
            If DWParams.ItemsString['Result'] <> Nil Then
             Begin
              If (BinaryEvent) And (Not (vError)) Then
               DWParams.ItemsString['Result'].LoadFromStream(BinaryBlob)
              Else If Not (vError) And (vTempJSON <> '') Then
               DWParams.ItemsString['Result'].SetValue(vTempJSON,
                                                       DWParams.ItemsString['Result'].Encoded)
              Else
               DWParams.ItemsString['Result'].SetValue('');
             End;
           End;
          Break;
         End;
       End;
     End;
   End;
 Finally
  If Assigned(BinaryBlob) Then
   FreeAndNil(BinaryBlob);
 End;
End;

procedure TRESTServiceCGI.InsertMySQLReturnID(ServerMethodsClass : TComponent;
                                              Var Pooler         : String;
                                              Var DWParams       : TDWParams;
                                              ConnectionDefs     : TConnectionDefs;
                                              hEncodeStrings     : Boolean;
                                              AccessTag          : String);
Var
 I,
 vTempJSON     : Integer;
 vError        : Boolean;
 vMessageError : String;
 DWParamsD     : TDWParams;
Begin
 DWParamsD := Nil;
 If ServerMethodsClass <> Nil Then
  Begin
   For I := 0 To ServerMethodsClass.ComponentCount -1 Do
    Begin
     If ServerMethodsClass.Components[i] is TRESTDWPoolerDB Then
      Begin
       If UpperCase(Pooler) = UpperCase(Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name])) then
        Begin
         If Trim(TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag) <> '' Then
          Begin
           If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag <> AccessTag Then
            Begin
             DWParams.ItemsString['MessageError'].AsString := 'Invalid Access tag...';
             DWParams.ItemsString['Error'].AsBoolean       := True;
             Exit;
            End;
          End;
         If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver <> Nil Then
          Begin
           vError   := DWParams.ItemsString['Error'].AsBoolean;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.Encoding          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).Encoding;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.EncodeStringsJSON := hEncodeStrings;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsEmpty2Null    := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsEmpty2Null;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim2Len      := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim2Len;
           If DWParams.ItemsString['Params'] <> Nil Then
            Begin
             DWParamsD := TDWParams.Create;
             DWParamsD.FromJSON(DWParams.ItemsString['Params'].Value);
            End;
           Try
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.PrepareConnection(ConnectionDefs);
            If DWParamsD <> Nil Then
             Begin
              vTempJSON := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.InsertMySQLReturnID(DWParams.ItemsString['SQL'].Value,
                                                                                                            DWParamsD, vError, vMessageError);
              DWParamsD.Free;
             End
            Else
             vTempJSON := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.InsertMySQLReturnID(DWParams.ItemsString['SQL'].Value,
                                                                                                           vError,
                                                                                                           vMessageError);
           Except
            On E : Exception Do
             Begin
              vMessageError := e.Message;
              vError := True;
             End;
           End;
           If vMessageError <> '' Then
            Begin
             DWParams.ItemsString['MessageError'].CriptOptions.Use := False;
             DWParams.ItemsString['MessageError'].AsString := EncodeStrings(vMessageError{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
            End;
           DWParams.ItemsString['Error'].AsBoolean := vError;
           If DWParams.ItemsString['Result'] <> Nil Then
            Begin
             If vTempJSON <> -1 Then
              DWParams.ItemsString['Result'].SetValue(IntToStr(vTempJSON),
                                                      DWParams.ItemsString['Result'].Encoded)
             Else
              DWParams.ItemsString['Result'].SetValue('-1');
            End;
          End;
         Break;
        End;
      End;
    End;
  End;
End;

procedure TRESTServiceCGI.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = vRESTServiceNotification) then
  begin
    vRESTServiceNotification := nil;
  end;

  inherited Notification(AComponent, Operation);
end;

procedure TRESTServiceCGI.ApplyUpdatesJSON(ServerMethodsClass : TComponent;
                                           Var Pooler         : String;
                                           Var DWParams       : TDWParams;
                                           ConnectionDefs     : TConnectionDefs;
                                           hEncodeStrings     : Boolean;
                                           AccessTag          : String);
Var
 vRowsAffected,
 I             : Integer;
 vTempJSON     : TJSONValue;
 vError        : Boolean;
 vSQL,
 vMessageError : String;
 DWParamsD     : TDWParams;
Begin
 DWParamsD := Nil;
 vRowsAffected := 0;
 If ServerMethodsClass <> Nil Then
  Begin
   For I := 0 To ServerMethodsClass.ComponentCount -1 Do
    Begin
     If ServerMethodsClass.Components[i] is TRESTDWPoolerDB Then
      Begin
       If UpperCase(Pooler) = UpperCase(Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name])) then
        Begin
         If Trim(TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag) <> '' Then
          Begin
           If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag <> AccessTag Then
            Begin
             DWParams.ItemsString['MessageError'].AsString := 'Invalid Access tag...';
             DWParams.ItemsString['Error'].AsBoolean       := True;
             Exit;
            End;
          End;
         If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver <> Nil Then
          Begin
           vError   := DWParams.ItemsString['Error'].AsBoolean;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.Encoding          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).Encoding;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.EncodeStringsJSON := hEncodeStrings;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsEmpty2Null    := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsEmpty2Null;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim2Len      := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim2Len;
           If DWParams.ItemsString['Params'] <> Nil Then
            Begin
             DWParamsD := TDWParams.Create;
             DWParamsD.FromJSON(DWParams.ItemsString['Params'].Value);
            End;
           If DWParams.ItemsString['SQL'] <> Nil Then
            vSQL := DWParams.ItemsString['SQL'].Value;
           Try
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.PrepareConnection(ConnectionDefs);
            DWParams.ItemsString['Massive'].CriptOptions.Use := False;
            vTempJSON := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.ApplyUpdates(DWParams.ItemsString['Massive'].AsString,
                                                                                                   vSQL,
                                                                                                   DWParamsD, vError, vMessageError, vRowsAffected);
            If DWParamsD <> Nil Then
             DWParamsD.Free;
           Except
            On E : Exception Do
             Begin
              vMessageError := e.Message;
              vError := True;
             End;
           End;
           If vMessageError <> '' Then
            Begin
             DWParams.ItemsString['MessageError'].CriptOptions.Use := False;
             DWParams.ItemsString['MessageError'].AsString := EncodeStrings(vMessageError{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
            End;
           DWParams.ItemsString['Error'].AsBoolean        := vError;
           If (DWParams.ItemsString['RowsAffected'] <> Nil) Then
            DWParams.ItemsString['RowsAffected'].AsInteger := vRowsAffected;
           If (DWParams.ItemsString['Result'] <> Nil) And Not(vError) Then
            Begin
             DWParams.ItemsString['Result'].CriptOptions.Use := False;
             If vTempJSON <> Nil Then
              DWParams.ItemsString['Result'].SetValue(vTempJSON.ToJSON,
                                                      DWParams.ItemsString['Result'].Encoded)
             Else
              DWParams.ItemsString['Result'].SetValue('');
            End;
          End;
         Break;
        End;
      End;
    End;
  End;
 If Not(vError) Then
  If Assigned(vTempJSON) Then
   FreeAndNil(vTempJSON);
End;


Function TRESTServiceCGI.ReturnContext(ServerMethodsClass : TComponent;
                                       Var Pooler,
                                       vResult,
                                       urlContext,
                                       ContentType             : String;
                                       Var ServerContextStream : TMemoryStream;
                                       Var Error               : Boolean;
                                       Var   DWParams          : TDWParams;
                                       Const RequestType       : TRequestType;
                                       mark                    : String;
                                       RequestHeader           : TStringList;
                                       Var ErrorCode           : Integer) : Boolean;
Var
 I             : Integer;
 vRejected,
 vTagService,
 vDefaultPageB : Boolean;
 vBaseHeader,
 vErrorMessage,
 vStrAcceptedRoutes,
 vRootContext  : String;
 vDWRoutes     : TDWRoutes;
Begin
 Result        := False;
 Error         := False;
 vDefaultPageB := False;
 vRejected     := False;
 vTagService   := Result;
 vRootContext  := '';
 vErrorMessage := '';
 If (Pooler <> '') And (urlContext = '') Then
  Begin
   urlContext := Pooler;
   Pooler     := '';
  End;
 If ServerMethodsClass <> Nil Then
  Begin
   For I := 0 To ServerMethodsClass.ComponentCount -1 Do
    Begin
     If ServerMethodsClass.Components[i] is TDWServerContext Then
      Begin
       If ((LowerCase(urlContext) = LowerCase(TDWServerContext(ServerMethodsClass.Components[i]).BaseContext))) Or
          ((Trim(TDWServerContext(ServerMethodsClass.Components[i]).BaseContext) = '') And (Pooler = '')        And
           (TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[urlContext] <> Nil))   Then
        Begin
         vRootContext := TDWServerContext(ServerMethodsClass.Components[i]).RootContext;
         If ((Pooler = '')    And (vRootContext <> '')) Then
          Pooler := vRootContext;
         vTagService := TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler] <> Nil;
         If Not vTagService Then
          Begin
           Error   := True;
           vResult := cInvalidRequest;
          End;
        End;
       If vTagService Then
        Begin
         Result   := True;
         If (RequestTypeToRoute(RequestType) In TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].Routes) Or
            (crAll in TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].Routes) Then
          Begin
           If Assigned(TDWServerContext(ServerMethodsClass.Components[i]).OnBeforeRenderer) Then
            TDWServerContext(ServerMethodsClass.Components[i]).OnBeforeRenderer(ServerMethodsClass.Components[i]);
           If Assigned(TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].OnAuthRequest) Then
            TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].OnAuthRequest(DWParams, vRejected, vErrorMessage, ErrorCode, RequestHeader);
           If Not vRejected Then
            Begin
             vResult := '';
             Try
              ContentType := TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].ContentType;
              TDWServerContext(ServerMethodsClass.Components[i]).CreateDWParams(Pooler, DWParams);
              If mark <> '' Then
               Begin
                vResult    := '';
                Result     := Assigned(TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].ContextRules);
                If Result Then
                 Begin
                  Result   := TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].ContextRules.Items.MarkByName[mark] <> Nil;
                  If Result Then
                   Begin
                    Result := Assigned(TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].ContextRules.Items.MarkByName[mark].OnRequestExecute);
                    If Result Then
                     Begin
                      ContentType := 'application/json';
                      TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].ContextRules.Items.MarkByName[mark].OnRequestExecute(DWParams, ContentType, vResult);
                     End;
                   End;
                 End;
               End
              Else If Assigned(TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].ContextRules) Then
               Begin
                vBaseHeader := '';
                ContentType := TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].ContextRules.ContentType;
                vResult := TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].ContextRules.BuildContext(TDWServerContext(ServerMethodsClass.Components[i]).BaseHeader,
                                                                                                                                          TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].IgnoreBaseHeader);
               End
              Else
               Begin
                If Assigned(TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].OnBeforeCall) Then
                 TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].OnBeforeCall(TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler]);
                vDefaultPageB := Not Assigned(TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].OnReplyRequest);
                If Not vDefaultPageB Then
                 TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].OnReplyRequest(DWParams, ContentType, vResult, RequestType);
                If Assigned(TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].OnReplyRequestStream) Then
                 Begin
                  vDefaultPageB := False;
                  ServerContextStream := TMemoryStream.Create;
                  Try
                   TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].OnReplyRequestStream(DWParams, ContentType, ServerContextStream, RequestType, ErrorCode);
                  Finally
                   If ServerContextStream.Size = 0 Then
                    FreeAndNil(ServerContextStream);
                  End;
                 End;
                If vDefaultPageB Then
                 Begin
                  vBaseHeader := '';
                  If Assigned(TDWServerContext(ServerMethodsClass.Components[i]).BaseHeader) Then
                   vBaseHeader := TDWServerContext(ServerMethodsClass.Components[i]).BaseHeader.Text;
                  vResult := TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].DefaultHtml.Text;
                  If Assigned(TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].OnBeforeRenderer) Then
                   TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].OnBeforeRenderer(vBaseHeader, ContentType, vResult, RequestType);
                 End;
               End;
             Except
              On E : Exception Do
               Begin
                //Alexandre Magno - 22/01/2019
                If DWParams.ItemsString['dwencodestrings'] <> Nil Then
                 vResult := EncodeStrings(e.Message{$IFDEF FPC}, vDatabaseCharSet{$ENDIF})
                Else
                 vResult := e.Message;
                Error := True;
                Exit;
               End;
             End;
            End
           Else
            Begin
             If vErrorMessage <> '' Then
              Begin
               ContentType := 'text/html';
               vResult     := vErrorMessage;
              End
             Else
              vResult   := cRequestRejected;
            End;
           If Trim(vResult) = '' Then
            vResult := TReplyOK;
          End
         Else
          Begin
           vStrAcceptedRoutes := '';
           vDWRoutes := TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler].Routes;
           If crGet in vDWRoutes Then
            Begin
             If vStrAcceptedRoutes <> '' Then
              vStrAcceptedRoutes := vStrAcceptedRoutes + ', GET'
             Else
              vStrAcceptedRoutes := 'GET';
            End;
           If crPost in vDWRoutes Then
            Begin
             If vStrAcceptedRoutes <> '' Then
              vStrAcceptedRoutes := vStrAcceptedRoutes + ', POST'
             Else
              vStrAcceptedRoutes := 'POST';
            End;
           If crPut in vDWRoutes Then
            Begin
             If vStrAcceptedRoutes <> '' Then
              vStrAcceptedRoutes := vStrAcceptedRoutes + ', PUT'
             Else
              vStrAcceptedRoutes := 'PUT';
            End;
           If crPatch in vDWRoutes Then
            Begin
             If vStrAcceptedRoutes <> '' Then
              vStrAcceptedRoutes := vStrAcceptedRoutes + ', PATCH'
             Else
              vStrAcceptedRoutes := 'PATCH';
            End;
           If crDelete in vDWRoutes Then
            Begin
             If vStrAcceptedRoutes <> '' Then
              vStrAcceptedRoutes := vStrAcceptedRoutes + ', DELETE'
             Else
              vStrAcceptedRoutes := 'DELETE';
            End;
           If vStrAcceptedRoutes <> '' Then
            Begin
             vResult   := cRequestRejectedMethods + vStrAcceptedRoutes;
             ErrorCode := 403;
            End
           Else
            Begin
             vResult   := cRequestAcceptableMethods;
             ErrorCode := 500;
            End;
          End;
         Break;
        End;
      End;
    End;
  End;
End;

Function TRESTServiceCGI.ReturnEvent(ServerMethodsClass : TComponent;
                                     Var Pooler,
                                     vResult,
                                     urlContext         : String;
                                     Var DWParams       : TDWParams;
                                     Var JsonMode       : TJsonMode;
                                     Var ErrorCode      : Integer;
                                     Var ContentType,
                                     AccessTag          : String;
                                     Const RequestType  : TRequestType;
                                     RequestHeader      : TStringList) : Boolean;
Var
 I : Integer;
 vRejected,
 vTagService   : Boolean;
 vStrAcceptedRoutes,
 vErrorMessage : String;
 vDWRoutes: TDWRoutes;
Begin
 Result        := False;
 vRejected     := False;
 vTagService   := Result;
 vErrorMessage := '';
 If ServerMethodsClass <> Nil Then
  Begin
   For I := 0 To ServerMethodsClass.ComponentCount -1 Do
    Begin
     If ServerMethodsClass.Components[i] is TDWServerEvents Then
      Begin
       If (LowerCase(urlContext) = LowerCase(TDWServerEvents(ServerMethodsClass.Components[i]).ContextName)) Or
          (LowerCase(urlContext) = LowerCase(ServerMethodsClass.Components[i].Name))  Or
          (LowerCase(urlContext) = LowerCase(ServerMethodsClass.classname + '.' +
                                             ServerMethodsClass.Components[i].Name))  Then
        vTagService := TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler] <> Nil;
       If vTagService Then
        Begin
         Result   := True;
         JsonMode := jmPureJSON;
         If Trim(TDWServerEvents(ServerMethodsClass.Components[i]).AccessTag) <> '' Then
          Begin
           If TDWServerEvents(ServerMethodsClass.Components[i]).AccessTag <> AccessTag Then
            Begin
             If DWParams.ItemsString['dwencodestrings'] <> Nil Then
              vResult := EncodeStrings('Invalid Access tag...'{$IFDEF FPC}, vDatabaseCharSet{$ENDIF})
             Else
              vResult := 'Invalid Access tag...';
             Result  := True;
             If (ErrorCode <= 0)  Or
                (ErrorCode = 200) Then
              ErrorCode := 500;
             Break;
            End;
          End;
         If (RequestTypeToRoute(RequestType) In TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler].Routes) Or
            (crAll in TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler].Routes) Then
          Begin
           TDWServerEvents(ServerMethodsClass.Components[i]).CreateDWParams(Pooler, DWParams);
           If Assigned(TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler].OnAuthRequest) Then
            TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler].OnAuthRequest(DWParams, vRejected, vErrorMessage, ErrorCode, RequestHeader);
           If Not vRejected Then
            Begin
             vResult    := '';
             Try
              If Assigned(TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler].OnBeforeExecute) Then
               TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler].OnBeforeExecute(TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler]);
              If Assigned(TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler].OnReplyEventByType) Then
               TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler].OnReplyEventByType(DWParams, vResult, RequestType, ErrorCode, RequestHeader)
              Else If Assigned(TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler].OnReplyEvent) Then
               TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler].OnReplyEvent(DWParams, vResult);
              JsonMode := TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler].JsonMode;
             Except
              On E : Exception Do
               Begin
                 //Alexandre Magno - 22/01/2019
                 If DWParams.ItemsString['dwencodestrings'] <> Nil Then
                  vResult := EncodeStrings(e.Message{$IFDEF FPC}, vDatabaseCharSet{$ENDIF})
                 Else
                  vResult := e.Message;
                Result  := True;
                If (ErrorCode <= 0)  Or
                   (ErrorCode = 200) Then
                 ErrorCode := 500;
//                Exit;
               End;
             End;
            End
           Else
            Begin
             If vErrorMessage <> '' Then
              Begin
               ContentType := 'text/html';
               vResult   := vErrorMessage;
              End
             Else
              vResult   := 'The Requested URL was Rejected';
             If (ErrorCode <= 0)  Or
                (ErrorCode = 200) Then
              ErrorCode := 403;
            End;
           If Trim(vResult) = '' Then
            vResult := TReplyOK;
          End
         Else
          Begin
           vStrAcceptedRoutes := '';
           vDWRoutes := TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler].Routes;
           If crGet in vDWRoutes Then
            Begin
             If vStrAcceptedRoutes <> '' Then
              vStrAcceptedRoutes := vStrAcceptedRoutes + ', GET'
             Else
              vStrAcceptedRoutes := 'GET';
            End;
           If crPost in vDWRoutes Then
            Begin
               If vStrAcceptedRoutes <> '' Then
                vStrAcceptedRoutes := vStrAcceptedRoutes + ', POST'
               Else
                vStrAcceptedRoutes := 'POST';
            End;
           If crPut in vDWRoutes Then
            Begin
             If vStrAcceptedRoutes <> '' Then
              vStrAcceptedRoutes := vStrAcceptedRoutes + ', PUT'
             Else
              vStrAcceptedRoutes := 'PUT';
            End;
           If crPatch in vDWRoutes Then
            Begin
             If vStrAcceptedRoutes <> '' Then
              vStrAcceptedRoutes := vStrAcceptedRoutes + ', PATCH'
             Else
              vStrAcceptedRoutes := 'PATCH';
            End;
           If crDelete in vDWRoutes Then
            Begin
             If vStrAcceptedRoutes <> '' Then
              vStrAcceptedRoutes := vStrAcceptedRoutes + ', DELETE'
             Else
              vStrAcceptedRoutes := 'DELETE';
            End;
           if vStrAcceptedRoutes <> '' then
            begin
              vResult   := 'Request rejected. Acceptable HTTP methods: '+vStrAcceptedRoutes;
              ErrorCode := 403;
            end
           else
            begin
              vResult   := 'Acceptable HTTP methods not defined on server';
              ErrorCode := 500;
            end;
          End;
         Break;
        End
       Else
         vResult := 'Event not found...';
      End;
    End;
  End;
 If Not vTagService Then
  If (ErrorCode <= 0)  Or
     (ErrorCode = 200) Then
   ErrorCode := 404;
End;

Procedure TRESTServiceCGI.GetEvents(ServerMethodsClass : TComponent;
                                    Var Pooler,
                                    urlContext         : String;
                                    Var DWParams       : TDWParams);
Var
 I         : Integer;
 vError    : Boolean;
 vTempJSON : String;
 iContSE   : Integer;
Begin
 vTempJSON := '';
 If ServerMethodsClass <> Nil Then
  Begin
   iContSE := 0;
   For I := 0 To ServerMethodsClass.ComponentCount -1 Do
    Begin
     If ServerMethodsClass.Components[i] is TDWServerEvents Then
      Begin
       iContSE := iContSE + 1;
       If (LowerCase(urlContext) = LowerCase(TDWServerEvents(ServerMethodsClass.Components[i]).ContextName)) or
          (LowerCase(urlContext) = LowerCase(ServerMethodsClass.Components[i].Name)) Or
          (LowerCase(urlContext) = LowerCase(Format('%s.%s', [ServerMethodsClass.Classname, ServerMethodsClass.Components[i].Name])))  Then
        Begin
         If vTempJSON = '' Then
          vTempJSON := Format('%s', [TDWServerEvents(ServerMethodsClass.Components[i]).Events.ToJSON])
         Else
          vTempJSON := vTempJSON + Format(', %s', [TDWServerEvents(ServerMethodsClass.Components[i]).Events.ToJSON]);
         Break;
        End;
      End;
    End;
   vError := vTempJSON = '';
   If vError Then
    Begin
     DWParams.ItemsString['MessageError'].AsString := 'Event Not Found';
     If iContSE > 1 then
      DWParams.ItemsString['MessageError'].AsString := 'There is more than one ServerEvent.'+ sLineBreak +
                                                       'Choose the desired ServerEvent in the ServerEventName property.';
    End;
   DWParams.ItemsString['Error'].AsBoolean        := vError;
   If DWParams.ItemsString['Result'] <> Nil Then
    Begin
     If vTempJSON <> '' Then
      DWParams.ItemsString['Result'].SetValue(Format('[%s]', [vTempJSON]), DWParams.ItemsString['Result'].Encoded)
     Else
      DWParams.ItemsString['Result'].SetValue('');
    End;
  End;
End;

procedure TRESTServiceCGI.OpenDatasets(ServerMethodsClass   : TComponent;
                                       Var Pooler           : String;
                                       Var DWParams         : TDWParams;
                                       ConnectionDefs       : TConnectionDefs;
                                       hEncodeStrings       : Boolean;
                                       AccessTag            : String;
                                       BinaryRequest        : Boolean);
Var
 I         : Integer;
 vTempJSON : TJSONValue;
 vError    : Boolean;
 vMessageError : String;
 BinaryBlob    : TMemoryStream;
Begin
 BinaryBlob    := Nil;
 Try
  If ServerMethodsClass <> Nil Then
   Begin
    For I := 0 To ServerMethodsClass.ComponentCount -1 Do
     Begin
      If ServerMethodsClass.Components[i] is TRESTDWPoolerDB Then
       Begin
        If UpperCase(Pooler) = UpperCase(Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name])) then
         Begin
          If Trim(TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag) <> '' Then
           Begin
            If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag <> AccessTag Then
             Begin
              DWParams.ItemsString['MessageError'].AsString := 'Invalid Access tag...';
              DWParams.ItemsString['Error'].AsBoolean       := True;
              Exit;
             End;
           End;
          If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver <> Nil Then
           Begin
            vError   := DWParams.ItemsString['Error'].AsBoolean;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.Encoding          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).Encoding;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.EncodeStringsJSON := hEncodeStrings;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsEmpty2Null    := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsEmpty2Null;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim2Len      := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim2Len;
//            DWParams.ItemsString['LinesDataset'].CriptOptions.Use := False;
            Try
             TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.PrepareConnection(ConnectionDefs);
             vTempJSON := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.OpenDatasets(DWParams.ItemsString['LinesDataset'].Value,
                                                                                                    vError, vMessageError,
                                                                                                    BinaryBlob);
            Except
             On E : Exception Do
              Begin
               vMessageError := e.Message;
               vError := True;
              End;
            End;
            If vMessageError <> '' Then
             Begin
              DWParams.ItemsString['MessageError'].CriptOptions.Use := False;
              DWParams.ItemsString['MessageError'].AsString := EncodeStrings(vMessageError{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
             End;
            DWParams.ItemsString['Error'].AsBoolean        := vError;
            If DWParams.ItemsString['Result'] <> Nil Then
             Begin
              If BinaryRequest Then
               Begin
                If Not Assigned(BinaryBlob) Then
                 BinaryBlob  := TMemoryStream.Create;
                If Not vTempJSON.IsNull Then //vTempJSON <> Nil Then
                 Begin
                  vTempJSON.SaveToStream(BinaryBlob);
                  DWParams.ItemsString['Result'].LoadFromStream(BinaryBlob);
                  FreeAndNil(vTempJSON);
                 End
                Else
                 DWParams.ItemsString['Result'].SetValue('');
                FreeAndNil(BinaryBlob);
               End
              Else
               Begin
                If Not vTempJSON.IsNull Then //vTempJSON <> Nil Then
                 DWParams.ItemsString['Result'].SetValue(vTempJSON.ToJSON)
                Else
                 DWParams.ItemsString['Result'].SetValue('');
               End;
             End;
           End;
          Break;
         End;
       End;
     End;
   End;
 Finally
  If Assigned(vTempJSON) Then
   FreeAndNil(vTempJSON);
  If Assigned(BinaryBlob) Then
   FreeAndNil(BinaryBlob);
 End;
End;

Procedure TRESTServiceCGI.ProcessMassiveSQLCache(ServerMethodsClass      : TComponent;
                                                 Var Pooler              : String;
                                                 Var DWParams            : TDWParams;
                                                 ConnectionDefs          : TConnectionDefs;
                                                 hEncodeStrings          : Boolean;
                                                 AccessTag               : String);
Var
 I             : Integer;
 vError        : Boolean;
 vMessageError : String;
 vTempJSON     : TJSONValue;
Begin
 If ServerMethodsClass <> Nil Then
  Begin
   For I := 0 To ServerMethodsClass.ComponentCount -1 Do
    Begin
     If ServerMethodsClass.Components[i] is TRESTDWPoolerDB Then
      Begin
       If UpperCase(Pooler) = UpperCase(Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name])) then
        Begin
         If Trim(TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag) <> '' Then
          Begin
           If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag <> AccessTag Then
            Begin
             DWParams.ItemsString['MessageError'].AsString := 'Invalid Access tag...';
             DWParams.ItemsString['Error'].AsBoolean       := True;
             Exit;
            End;
          End;
         If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver <> Nil Then
          Begin
           vError   := DWParams.ItemsString['Error'].AsBoolean;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.Encoding          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).Encoding;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.EncodeStringsJSON := hEncodeStrings;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsEmpty2Null    := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsEmpty2Null;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim2Len      := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim2Len;
           Try
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.PrepareConnection(ConnectionDefs);
            vTempJSON := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.ProcessMassiveSQLCache(DWParams.ItemsString['MassiveSQLCache'].AsString,
                                                                                                   vError,  vMessageError);
           Except
            On E : Exception Do
             Begin
              vMessageError := e.Message;
              vError := True;
             End;
           End;
           If vMessageError <> '' Then
            Begin
             DWParams.ItemsString['MessageError'].CriptOptions.Use := False;
             DWParams.ItemsString['MessageError'].AsString := EncodeStrings(vMessageError{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
            End;
           DWParams.ItemsString['Error'].AsBoolean        := vError;
           If (DWParams.ItemsString['Result'] <> Nil) And Not(vError) Then
            Begin
             If vTempJSON <> Nil Then
              Begin
               DWParams.ItemsString['Result'].SetValue(vTempJSON.Value, DWParams.ItemsString['Result'].Encoded);
               vTempJSON.Free;
              End
             Else
              DWParams.ItemsString['Result'].SetValue('');
            End;
          End;
         Break;
        End;
      End;
    End;
  End;
End;

procedure TRESTServiceCGI.ApplyUpdates_MassiveCache(ServerMethodsClass : TComponent;
                                                    Var Pooler         : String;
                                                    Var DWParams       : TDWParams;
                                                    ConnectionDefs     : TConnectionDefs;
                                                    hEncodeStrings     : Boolean;
                                                    AccessTag          : String);
Var
 I             : Integer;
 vError        : Boolean;
 vMessageError : String;
Begin
 If ServerMethodsClass <> Nil Then
  Begin
   For I := 0 To ServerMethodsClass.ComponentCount -1 Do
    Begin
     If ServerMethodsClass.Components[i] is TRESTDWPoolerDB Then
      Begin
       If UpperCase(Pooler) = UpperCase(Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name])) then
        Begin
         If Trim(TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag) <> '' Then
          Begin
           If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag <> AccessTag Then
            Begin
             DWParams.ItemsString['MessageError'].AsString := 'Invalid Access tag...';
             DWParams.ItemsString['Error'].AsBoolean       := True;
             Exit;
            End;
          End;
         If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver <> Nil Then
          Begin
           vError   := DWParams.ItemsString['Error'].AsBoolean;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.Encoding          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).Encoding;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.EncodeStringsJSON := hEncodeStrings;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsEmpty2Null    := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsEmpty2Null;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim2Len      := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim2Len;
           Try
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.PrepareConnection(ConnectionDefs);
            //DWParams.ItemsString['MassiveCache'].CriptOptions.Use := False;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.ApplyUpdates_MassiveCache(DWParams.ItemsString['MassiveCache'].AsString,
                                                                                                   vError,  vMessageError);
           Except
            On E : Exception Do
             Begin
              vMessageError := e.Message;
              vError := True;
             End;
           End;
           If vMessageError <> '' Then
            Begin
             DWParams.ItemsString['MessageError'].CriptOptions.Use := False;
             DWParams.ItemsString['MessageError'].AsString := EncodeStrings(vMessageError{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
            End;
           DWParams.ItemsString['Error'].AsBoolean        := vError;
          End;
         Break;
        End;
      End;
    End;
  End;
End;

constructor TRESTServiceCGI.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  vDefaultPage  := TStringList.Create;
  vCORSCustomHeaders := TStringList.Create;
  vTokenOptions      := TServerTokenOptions.Create;
  vCORSCustomHeaders.Add('Access-Control-Allow-Origin=*');
  vCORSCustomHeaders.Add('Access-Control-Allow-Methods=GET, POST, PATCH, PUT, DELETE, OPTIONS');
  vCORSCustomHeaders.Add('Access-Control-Allow-Headers=Content-Type, Origin, Accept, Authorization, X-CUSTOM-HEADER');
  vServerParams := TServerParams.Create(Self);
  vCripto       := TCripto.Create;
  vServerParams.HasAuthentication := True;
  vForceWelcomeAccess             := False;
  vServerParams.UserName          := 'testserver';
  vServerParams.Password          := 'testserver';
  vServerContext                  := 'restdataware';
  VEncondig                       := esUtf8;
  FRootPath                       := '/';
  vCORS                           := False;
  {$IFDEF FPC}
   vDatabaseCharSet               := csUndefined;
  {$ENDIF}
end;

destructor TRESTServiceCGI.Destroy;
begin
  vServerParams.Free;
  FreeAndNil(vDefaultPage);
  FreeAndNil(vCORSCustomHeaders);
  FreeAndNil(vCripto);
  FreeAndNil(vTokenOptions);
  inherited Destroy;
end;

Constructor TRESTClientPooler.Create(AOwner: TComponent);
Begin
 Inherited;
 LHandler                        := nil;
 HttpRequest                     := TIdHTTP.Create(Nil);
 vCripto                         := TCripto.Create;
 vTokenOptions                   := TClientTokenOptions.Create;
 HttpRequest.Request.ContentType := 'application/json';
 HttpRequest.AllowCookies        := False;
 HttpRequest.HTTPOptions         := [hoKeepOrigProtocol];
 vTransparentProxy               := TIdProxyConnectionInfo.Create;
 vHost                           := 'localhost';
 vPort                           := 8082;
 vUserName                       := 'testserver';
 vPassword                       := 'testserver';
 vRSCharset                      := esUtf8;
 vAuthentication                 := True;
 vRequestTimeOut                 := 10000;
 vThreadRequest                  := False;
 vDatacompress                   := True;
 vEncodeStrings                  := True;
 vBinaryRequest                  := False;
 vUserAgent                      := cUserAgent;
 {$IFDEF FPC}
 vDatabaseCharSet                := csUndefined;
 {$ENDIF}
 vFailOver                 := False;
 vFailOverReplaceDefaults  := False;
 vFailOverConnections      := TFailOverConnections.Create(Self, TRESTDWConnectionServerCP);
End;

Destructor  TRESTClientPooler.Destroy;
Begin
 Try
  If HttpRequest.Connected Then
   HttpRequest.Disconnect;
 Except
 End;
 If Assigned(LHandler) then
  FreeAndNil(LHandler);
 FreeAndNil(HttpRequest);
 FreeAndNil(vTransparentProxy);
 FreeAndNil(vFailOverConnections);
 FreeAndNil(vCripto);
 FreeAndNil(vTokenOptions);
 Inherited;
End;

Function TRESTClientPooler.GetAccessTag: String;
Begin
 Result := vAccessTag;
End;

Function TRESTClientPooler.GetAllowCookies: Boolean;
Begin
 Result := HttpRequest.AllowCookies;
End;

Function TRESTClientPooler.GetHandleRedirects : Boolean;
Begin
 Result := HttpRequest.HandleRedirects;
End;

Function TRESTClientPooler.SendEvent(EventData       : String;
                                     Var Params      : TDWParams;
                                     EventType       : TSendEvent = sePOST;
                                     JsonMode        : TJsonMode  = jmDataware;
                                     ServerEventName : String     = '';
                                     Assyncexec      : Boolean    = False;
                                     CallBack        : TCallBack  = Nil) : String; //C�digo original VCL e LCL
Var
 vErrorMessage,
 vDataPack,
 SResult, vURL,
 vTpRequest       : String;
 I                : Integer;
 vDWParam         : TJSONParam;
 MemoryStream,
 vResultParams    : TMemoryStream;
 aStringStream,
 bStringStream,
 StringStream     : TStringStream;
 SendParams       : TIdMultipartFormDataStream;
 StringStreamList : TStringStreamList;
 JSONValue        : TJSONValue;
 aBinaryCompatibleMode,
 aBinaryRequest   : Boolean;
 Procedure SetData(Var InputValue : String;
                   Var ParamsData : TDWParams;
                   Var ResultJSON : String);
 Var
  bJsonOBJ,
  bJsonValue    : TDWJSONObject;
  bJsonOBJTemp  : TDWJSONArray;
  JSONParam,
  JSONParamNew  : TJSONParam;
  A, InitPos    : Integer;
  vValue,
  aValue,
  vTempValue    : String;
 Begin
  ResultJSON := InputValue;
  If Pos(', "RESULT":[', InputValue) = 0 Then
   Begin
    If (vRSCharset = esUtf8) Then //NativeResult Corre��es aqui
     Begin
      {$IFDEF FPC}
       ResultJSON := GetStringDecode(InputValue, DatabaseCharSet);
      {$ELSE}
       {$IF (CompilerVersion > 22)}
        ResultJSON := PWidechar(InputValue); //PWidechar(UTF8Decode(InputValue));
       {$ELSE}
        ResultJSON := UTF8Decode(ResultJSON); //Corre��o para Delphi's Antigos de Charset.
       {$IFEND}
      {$ENDIF}
     End
    Else
     ResultJSON := InputValue;
    Exit;
   End;
  Try
//   InitPos    := Pos(', "RESULT":[', InputValue) + Length(', "RESULT":[') ;
   If (Pos(', "RESULT":[{"MESSAGE":"', InputValue) > 0) Then
    InitPos   := Pos(', "RESULT":[{"MESSAGE":"', InputValue) + Length(', "RESULT":[')   //TODO Brito
   Else If (Pos(', "RESULT":[', InputValue) > 0) Then
    InitPos   := Pos(', "RESULT":[', InputValue) + Length(', "RESULT":[')
   Else If (Pos('{"PARAMS":[{"', InputValue) > 0)       And
            (Pos('", "RESULT":', InputValue) > 0)       Then
    InitPos   := Pos('", "RESULT":', InputValue) + Length('", "RESULT":');
   aValue   := Copy(InputValue, InitPos,    Length(InputValue) -1);
   If Pos(']}', aValue) > 0 Then
    aValue     := Copy(aValue, InitStrPos, Pos(']}', aValue) -1);
   vTempValue := aValue;
   InputValue := Copy(InputValue, InitStrPos, InitPos-1) + ']}';//Delete(InputValue, InitPos, Pos(']}', InputValue) - InitPos);
   If (Params <> Nil) And (InputValue <> '{"PARAMS"]}') And (InputValue <> '') Then
    Begin
     {$IFDEF FPC}
      If vRSCharset = esUtf8 Then
       bJsonValue    := TDWJSONObject.Create(PWidechar(UTF8Decode(InputValue)))
      Else
       bJsonValue    := TDWJSONObject.Create(InputValue);
     {$ELSE}
      {$IF (CompilerVersion <= 22)}
       If vRSCharset = esUtf8 Then //Corre��o para Delphi's Antigos de Charset.
        bJsonValue    := TDWJSONObject.Create(PWidechar(UTF8Decode(InputValue)))
       Else
        bJsonValue    := TDWJSONObject.Create(InputValue);
      {$ELSE}
       bJsonValue    := TDWJSONObject.Create(InputValue);
      {$IFEND}
     {$ENDIF}
     InputValue    := '';
     If bJsonValue.PairCount > 0 Then
      Begin
       bJsonOBJTemp  := TDWJSONArray(bJsonValue.OpenArray(bJsonValue.pairs[0].name));
       If bJsonOBJTemp.ElementCount > 0 Then
        Begin
         For A := 0 To bJsonOBJTemp.ElementCount -1 Do
          Begin
           bJsonOBJ := TDWJSONObject(bJsonOBJTemp.GetObject(A));
           If Length(bJsonOBJ.Pairs[0].Value) = 0 Then
            Begin
             FreeAndNil(bJsonOBJ);
             Continue;
            End;
           If GetObjectName(bJsonOBJ.Pairs[0].Value) <> toParam Then
            Begin
             FreeAndNil(bJsonOBJ);
             Continue;
            End;
           JSONParam := TJSONParam.Create(vRSCharset);
           Try
            JSONParam.ParamName       := bJsonOBJ.Pairs[4].name;
            JSONParam.ObjectValue     := GetValueType(bJsonOBJ.Pairs[3].Value);
            JSONParam.ObjectDirection := GetDirectionName(bJsonOBJ.Pairs[1].Value);
            JSONParam.Encoded         := GetBooleanFromString(bJsonOBJ.Pairs[2].Value);
            If Not(JSONParam.ObjectValue In [ovBlob, ovStream, ovGraphic, ovOraBlob, ovOraClob]) Then
             Begin
              If (JSONParam.Encoded) Then
               Begin
                {$IFDEF FPC}
                 vValue := DecodeStrings(bJsonOBJ.Pairs[4].Value{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
                {$ELSE}
                 vValue := DecodeStrings(bJsonOBJ.Pairs[4].Value{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
                 {$if CompilerVersion < 21}
                 If vRSCharset = esUtf8 Then
                  vValue := Utf8Decode(vValue);
                 vValue := AnsiString(vValue);
                 {$IFEND}
                {$ENDIF}
               End
              Else If JSONParam.ObjectValue <> ovObject then
               vValue := bJsonOBJ.Pairs[4].Value
              Else                                            //TODO Brito
               Begin
                vValue := bJsonOBJ.Pairs[4].Value;
                DeleteInvalidChar(vValue);
               End;
             End
            Else
             vValue := bJsonOBJ.Pairs[4].Value;
            JSONParam.SetValue(vValue, JSONParam.Encoded);
            //parametro criandos no servidor
            If ParamsData.ItemsString[JSONParam.ParamName] = Nil Then
             Begin
              JSONParamNew           := TJSONParam.Create(ParamsData.Encoding);
              JSONParamNew.ParamName := JSONParam.ParamName;
              JSONParamNew.ObjectDirection := JSONParam.ObjectDirection;
              JSONParamNew.SetValue(JSONParam.Value, JSONParam.Encoded);
              ParamsData.Add(JSONParamNew);
             End
            Else If Not (ParamsData.ItemsString[JSONParam.ParamName].Binary) Then
             ParamsData.ItemsString[JSONParam.ParamName].Value := JSONParam.Value
            Else
             ParamsData.ItemsString[JSONParam.ParamName].SetValue(vValue, JSONParam.Encoded);
           Finally
            FreeAndNil(JSONParam);
            //Magno - 28/08/2018
            FreeAndNil(bJsonOBJ);
           End;
          End;
        End;
      End;
//     bJsonValue.Clean;
     FreeAndNil(bJsonValue);
     //Magno - 28/08/2018
     FreeAndNil(bJsonOBJTemp);
    End;
  Finally
   If vTempValue <> '' Then
    ResultJSON := vTempValue;
   vTempValue := '';
  End;
 End;
 Function GetParamsValues(Var DWParams : TDWParams{$IFDEF FPC};vDatabaseCharSet : TDatabaseCharSet{$ENDIF}) : String;
 Var
  I         : Integer;
 Begin
  Result := '';
  JSONValue := Nil;
  If WelcomeMessage <> '' Then
   Result := 'dwwelcomemessage=' + EncodeStrings(WelcomeMessage{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
  If AccessTag <> '' Then
   Begin
    If Result <> '' Then
     Result := Result + '&dwaccesstag=' + EncodeStrings(AccessTag{$IFDEF FPC}, vDatabaseCharSet{$ENDIF})
    Else
     Result := 'dwaccesstag=' + EncodeStrings(AccessTag{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
   End;
  If ServerEventName <> '' Then
   Begin
    If Assigned(DWParams) Then
     Begin
      vDWParam             := DWParams.ItemsString['dwservereventname'];
      If Not Assigned(vDWParam) Then
       Begin
        vDWParam           := TJSONParam.Create(DWParams.Encoding);
        vDWParam.ObjectDirection := odIN;
        DWParams.Add(vDWParam);
       End;
      Try
       vDWParam.Encoded   := True;
       vDWParam.ParamName := 'dwservereventname';
       vDWParam.SetValue(ServerEventName, vDWParam.Encoded);
      Finally
//       FreeAndNil(JSONValue);
      End;
     End
    Else
     Begin
      JSONValue            := TJSONValue.Create;
      Try
       JSONValue.Encoding  := DWParams.Encoding;
       JSONValue.Encoded   := True;
       JSONValue.Tagname   := 'dwservereventname';
       JSONValue.SetValue(ServerEventName, JSONValue.Encoded);
      Finally
       If Result <> '' Then
        Result := Result + '&dwservereventname=' + EncodeStrings(JSONValue.ToJSON{$IFDEF FPC}, vDatabaseCharSet{$ENDIF})
       Else
        Result := 'dwservereventname=' + EncodeStrings(JSONValue.ToJSON{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
       FreeAndNil(JSONValue);
      End;
    End;
   End;
  If Result <> '' Then
   Result := Result + '&datacompression=' + BooleanToString(vDatacompress)
  Else
   Result := 'datacompression=' + BooleanToString(vDatacompress);
  If Result <> '' Then
   Result := Result + '&dwassyncexec=' + BooleanToString(Assyncexec)
  Else
   Result := 'dwassyncexec=' + BooleanToString(Assyncexec);
  If Result <> '' Then
   Result := Result + '&dwencodestrings=' + BooleanToString(hEncodeStrings)
  Else
   Result := 'dwencodestrings=' + BooleanToString(hEncodeStrings);
  If Result <> '' Then
   Begin
    If Assigned(vCripto) Then
     If vCripto.Use Then
      Result := Result + '&dwusecript=true';
   End
  Else
   Begin
    If Assigned(vCripto) Then
     If vCripto.Use Then
      Result := 'dwusecript=true';
   End;
  If DWParams <> Nil Then
   Begin
    For I := 0 To DWParams.Count -1 Do
     Begin
      If Result <> '' Then
       Begin
        If DWParams.Items[I].ObjectValue in [ovSmallint, ovInteger, ovWord, ovBoolean, ovByte,
                                             ovAutoInc, ovLargeint, ovLongWord, ovShortint, ovSingle] Then
         Result := Result + Format('&%s=%s', [DWParams.Items[I].ParamName, DWParams.Items[I].Value])
        Else
         Begin
          If vCripto.Use Then
           Result := Result + Format('&%s=%s', [DWParams.Items[I].ParamName, vCripto.Encrypt(DWParams.Items[I].Value)])
          Else
           Result := Result + Format('&%s=%s', [DWParams.Items[I].ParamName, EncodeStrings(DWParams.Items[I].Value{$IFDEF FPC}, vDatabaseCharSet{$ENDIF})]);
         End;
       End
      Else
       Begin
        If DWParams.Items[I].ObjectValue in [ovSmallint, ovInteger, ovWord, ovBoolean, ovByte,
                                             ovAutoInc, ovLargeint, ovLongWord, ovShortint, ovSingle] Then
         Result := Format('%s=%s', [DWParams.Items[I].ParamName, DWParams.Items[I].Value])
        Else
         Begin
          If vCripto.Use Then
           Result := Format('%s=%s', [DWParams.Items[I].ParamName, vCripto.Encrypt(DWParams.Items[I].Value)])
          Else
           Result := Format('%s=%s', [DWParams.Items[I].ParamName, EncodeStrings(DWParams.Items[I].Value{$IFDEF FPC}, vDatabaseCharSet{$ENDIF})]);
         End;
       End;
     End;
   End;
//  If Result <> '' Then
//   Result := '?' + Result;
 End;
 Procedure SetParamsValues(DWParams : TDWParams; SendParamsData : TIdMultipartFormDataStream);
 Var
  I : Integer;
 Begin
  MemoryStream  := Nil;
  If DWParams   <> Nil Then
   Begin
    If Not (Assigned(StringStreamList)) Then
     StringStreamList := TStringStreamList.Create;
    If BinaryRequest Then
     Begin
      MemoryStream := TMemoryStream.Create;
      DWParams.SaveToStream(MemoryStream);
      Try
       If Assigned(MemoryStream) Then
        Begin
         MemoryStream.Position := 0;
         {$IFNDEF FPC}
          {$IF (DEFINED(OLDINDY))}
           SendParamsData.AddObject( 'binarydata', 'application/octet-stream', MemoryStream); //StringStreamList.Items[StringStreamList.Count-1]);
          {$ELSE}
           SendParamsData.AddObject( 'binarydata', 'application/octet-stream', '', MemoryStream); //StringStreamList.Items[StringStreamList.Count-1]);
          {$IFEND}
         {$ELSE}
          SendParamsData.AddObject( 'binarydata', 'application/octet-stream', '', MemoryStream); //StringStreamList.Items[StringStreamList.Count-1]);
         {$ENDIF}
        End;
      Finally
      End;
     End
    Else
     Begin
      For I := 0 To DWParams.Count -1 Do
       Begin
        If DWParams.Items[I].ObjectValue in [ovWideMemo, ovBytes, ovVarBytes, ovBlob, ovStream,
                                             ovMemo,   ovGraphic, ovFmtMemo,  ovOraBlob, ovOraClob] Then
         Begin
          StringStreamList.Add({$IFDEF FPC}
                               TStringStream.Create(DWParams.Items[I].ToJSON)
                               {$ELSE}
                               TStringStream.Create(DWParams.Items[I].ToJSON{$if CompilerVersion > 21}, TEncoding.UTF8{$IFEND})
                               {$ENDIF});
          {$IFNDEF FPC}
           {$if CompilerVersion > 21}
            SendParamsData.AddObject(DWParams.Items[I].ParamName, 'multipart/form-data', HttpRequest.Request.Charset, StringStreamList.Items[StringStreamList.Count-1]);
           {$ELSE}
            {$IF (DEFINED(OLDINDY))}
             SendParamsData.AddObject(DWParams.Items[I].ParamName, 'multipart/form-data', StringStreamList.Items[StringStreamList.Count-1]);
            {$ELSE}
             SendParamsData.AddObject(DWParams.Items[I].ParamName, 'multipart/form-data', HttpRequest.Request.Charset, StringStreamList.Items[StringStreamList.Count-1]);
            {$IFEND}
           {$IFEND}
          {$ELSE}
           SendParamsData.AddObject(DWParams.Items[I].ParamName, 'multipart/form-data', HttpRequest.Request.Charset, StringStreamList.Items[StringStreamList.Count-1]);
          {$ENDIF}
         End
        Else
         SendParamsData.AddFormField(DWParams.Items[I].ParamName, DWParams.Items[I].ToJSON);
       End;
     End;
   End;
 End;
 Function BuildUrl(TpRequest     : TTypeRequest;
                   Host, UrlPath : String;
                   Port          : Integer) : String;
 Var
  vTpRequest : String;
 Begin
  Result := '';
  If TpRequest = trHttp Then
   vTpRequest := 'http'
  Else If TpRequest = trHttps Then
   vTpRequest := 'https';
  Result := LowerCase(Format(UrlBase, [vTpRequest, Host, Port, UrlPath])) + EventData;
 End;
 Procedure SetCharsetRequest(Var HttpRequest : TIdHTTP;
                             Charset         : TEncodeSelect);
 Begin
  If Charset = esUtf8 Then
   Begin
    HttpRequest.Request.ContentType := 'application/json;charset=utf-8';
    HttpRequest.Request.Charset := 'utf-8';
   End
  Else If Charset in [esANSI, esASCII] Then
   HttpRequest.Request.Charset := 'ansi';
 End;
 Function ExecRequest(EventType : TSendEvent;
                      URL,
                      WelcomeMessage,
                      AccessTag       : String;
                      Charset         : TEncodeSelect;
                      Datacompress,
                      hEncodeStrings,
                      BinaryRequest   : Boolean;
                      Var ResultData,
                      ErrorMessage    : String) : Boolean;
 Var
  vAccessURL,
  vWelcomeMessage,
  vUrl             : String;
  Function BuildValue(Name, Value : String) : String;
  Begin
   If vURL = URL + '?' Then
    Result := Format('%s=%s', [Name, Value])
   Else
    Result := Format('&%s=%s', [Name, Value]);
  End;
 Begin
  Result          := True;
  ResultData      := '';
  ErrorMessage    := '';
  vAccessURL      := '';
  vWelcomeMessage := '';
  vUrl            := '';
  vResultParams   := TMemoryStream.Create;
  Try
   HttpRequest.Request.UserAgent := vUserAgent;
   Case EventType Of
    seGET,
    seDELETE :
     Begin
      HttpRequest.Request.ContentType := 'application/json';
      vURL := URL + '?';
      If WelcomeMessage <> '' Then
       vURL := vURL + BuildValue('dwwelcomemessage', EncodeStrings(WelcomeMessage{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}));
      If (AccessTag <> '') Then
       vURL := vURL + BuildValue('dwaccesstag',      EncodeStrings(AccessTag{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}));
      vURL := vURL + BuildValue('datacompression',   BooleanToString(vDatacompress));
      vURL := vURL + BuildValue('dwassyncexec',      BooleanToString(Assyncexec));
      vURL := vURL + BuildValue('dwencodestrings',   BooleanToString(hEncodeStrings));
      vURL := vURL + BuildValue('binaryrequest',     BooleanToString(vBinaryRequest));
      If aBinaryCompatibleMode Then
       vURL := vURL + BuildValue('BinaryCompatibleMode', BooleanToString(aBinaryCompatibleMode));
      vURL := Format('%s&%s', [vURL, GetParamsValues(Params{$IFDEF FPC}, vDatabaseCharSet{$ENDIF})]);
      If Assigned(vCripto) Then
       vURL := vURL + BuildValue('dwusecript',       BooleanToString(vCripto.Use));
      If Not vThreadRequest Then
       Begin
        {$IFDEF FPC}
         aStringStream := TStringStream.Create('');
        {$ELSE}
         aStringStream := TStringStream.Create(''{$if CompilerVersion > 21}, TEncoding.UTF8{$IFEND});
        {$ENDIF}
        Case EventType Of
         seGET    : HttpRequest.Get(vURL, aStringStream);
         seDELETE : Begin
                     {$IFDEF FPC}
                      HttpRequest.Delete(vURL, aStringStream);
                     {$ELSE}
                      {$IFDEF OLDINDY}
                       HttpRequest.Delete(vURL);
                      {$ELSE}
                       //HttpRequest.Delete(AUrl, atempResponse);
                       TIdHTTPAccess(HttpRequest).DoRequest(Id_HTTPMethodDelete, vURL, SendParams, aStringStream, []);
                      {$ENDIF}
                     {$ENDIF}
                    End;
        end;
        If vDatacompress Then
         Begin
          If Assigned(aStringStream) Then
           Begin
            If aStringStream.Size > 0 Then
             StringStream := ZDecompressStreamNew(aStringStream);
            FreeAndNil(aStringStream);
            ResultData := StringStream.DataString;
            FreeAndNil(StringStream);
           End;
         End
        Else
         Begin
          ResultData := aStringStream.DataString;
          FreeAndNil(aStringStream);
         End;
       End
      Else
       Begin
        SResult    := HttpRequest.Get(vURL);
        ResultData := SResult;
        If Assigned(CallBack) Then
         CallBack(SResult, Params);
       End;
      If vRSCharset = esUtf8 Then
       ResultData := Utf8Decode(ResultData);
     End;
    sePOST,
    sePUT,
    sePATCH :
     Begin;
      SendParams := TIdMultiPartFormDataStream.Create;
      If WelcomeMessage <> '' Then
       SendParams.AddFormField('dwwelcomemessage', EncodeStrings(WelcomeMessage{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}));
      If AccessTag <> '' Then
       SendParams.AddFormField('dwaccesstag',      EncodeStrings(AccessTag{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}));
      If ServerEventName <> '' Then
       Begin
        If Assigned(Params) Then
         Begin
          vDWParam             := Params.ItemsString['dwservereventname'];
          If Not Assigned(vDWParam) Then
           vDWParam           := TJSONParam.Create(Params.Encoding);
          Try
           vDWParam.Encoded         := True;
           vDWParam.ObjectDirection := odIN;
           vDWParam.ParamName       := 'dwservereventname';
           vDWParam.SetValue(ServerEventName, vDWParam.Encoded);
          Finally
           If Params.ItemsString['dwservereventname'] = Nil Then
            Params.Add(vDWParam);
          End;
         End;
        JSONValue           := TJSONValue.Create;
        Try
         JSONValue.Encoding := Charset;
         JSONValue.Encoded  := True;
         JSONValue.Tagname  := 'dwservereventname';
         JSONValue.SetValue(ServerEventName, JSONValue.Encoded);
        Finally
         SendParams.AddFormField('dwservereventname', JSONValue.ToJSON);
         //Magno - 28/08/2018
         FreeAndNil(JSONValue);
        End;
       End;
      SendParams.AddFormField('datacompression',   BooleanToString(vDatacompress));
      SendParams.AddFormField('dwassyncexec',      BooleanToString(Assyncexec));
      SendParams.AddFormField('dwencodestrings',   BooleanToString(hEncodeStrings));
      SendParams.AddFormField('binaryrequest',     BooleanToString(vBinaryRequest));
      If aBinaryCompatibleMode Then
       SendParams.AddFormField('BinaryCompatibleMode', BooleanToString(aBinaryCompatibleMode));
      If Assigned(vCripto) Then
       SendParams.AddFormField('dwusecript',       BooleanToString(vCripto.Use));
      If Params <> Nil Then
       SetParamsValues(Params, SendParams);
      If (Params <> Nil) Or (WelcomeMessage <> '') Or (Datacompress) Then
       Begin
        HttpRequest.Request.Accept          := 'application/json';
        HttpRequest.Request.ContentType     := 'application/x-www-form-urlencoded';
        HttpRequest.Request.ContentEncoding := 'multipart/form-data';
        If TEncodeSelect(vRSCharset) = esUtf8 Then
         HttpRequest.Request.Charset        := 'Utf-8'
        Else If TEncodeSelect(vRSCharset) in [esANSI, esASCII] Then
         HttpRequest.Request.Charset        := 'ansi';
        If Not vBinaryRequest Then
         While HttpRequest.Request.CustomHeaders.IndexOfName('binaryrequest') > -1 Do
          HttpRequest.Request.CustomHeaders.Delete(HttpRequest.Request.CustomHeaders.IndexOfName('binaryrequest'));
        If Not aBinaryCompatibleMode Then
         While HttpRequest.Request.CustomHeaders.IndexOfName('BinaryCompatibleMode') > -1 Do
          HttpRequest.Request.CustomHeaders.Delete(HttpRequest.Request.CustomHeaders.IndexOfName('BinaryCompatibleMode'));
        HttpRequest.Request.UserAgent := vUserAgent;
        If vDatacompress Then
         Begin
          {$IFDEF FPC}
           aStringStream := TStringStream.Create('');
          {$ELSE}
           aStringStream := TStringStream.Create(''{$if CompilerVersion > 21}, TEncoding.UTF8{$IFEND});
          {$ENDIF}
          Case EventType Of
           sePUT    : HttpRequest.Put   (URL, SendParams, aStringStream);
           sePATCH  : HttpRequest.Patch (URL, SendParams, aStringStream);
           sePOST   : HttpRequest.Post  (URL, SendParams, aStringStream);
          end;
          If Assigned(aStringStream) Then
           Begin
            If aStringStream.Size > 0 Then
             StringStream := ZDecompressStreamNew(aStringStream);
            FreeAndNil(aStringStream);
           End;
         End
        Else
         Begin
          StringStream   := TStringStream.Create('');
          Case EventType Of
           sePUT    : HttpRequest.Put   (URL, SendParams, StringStream);
           sePATCH  : HttpRequest.Patch (URL, SendParams, StringStream);
           sePOST   : HttpRequest.Post  (URL, SendParams, StringStream);
          end;
         End;
        StringStream.Position := 0;
        If SendParams <> Nil Then
         Begin
          If Assigned(StringStreamList) Then
           FreeAndNil(StringStreamList);
          {$IFNDEF FPC}
           {$IF Not(DEFINED(OLDINDY))}
            SendParams.Clear;
           {$IFEND}
          {$ENDIF}
          FreeAndNil(SendParams);
         End;
       End
      Else
       Begin
        HttpRequest.Request.ContentType     := 'application/json';
        HttpRequest.Request.ContentEncoding := '';
        HttpRequest.Request.UserAgent       := vUserAgent;
        aStringStream := TStringStream.Create('');
        HttpRequest.Get(URL, aStringStream);
        aStringStream.Position := 0;
        StringStream   := TStringStream.Create('');
        bStringStream  := TStringStream.Create('');
        If vDatacompress Then
         Begin
          bStringStream.CopyFrom(aStringStream, aStringStream.Size);
          bStringStream.Position := 0;
          ZDecompressStreamD(bStringStream, StringStream);
         End
        Else
         Begin
          bStringStream.CopyFrom(aStringStream, aStringStream.Size);
          bStringStream.Position := 0;
          HexToStream(bStringStream.DataString, StringStream);
         End;
        FreeAndNil(bStringStream);
        FreeAndNil(aStringStream);
       End;
      HttpRequest.Request.Clear;
      StringStream.Position := 0;
      If vBinaryRequest Then
       Begin
        Params.LoadFromStream(StringStream);
        {$IFNDEF FPC}
         {$IF CompilerVersion > 21}
          StringStream.Clear;
         {$IFEND}
         StringStream.Size := 0;
        {$ENDIF}
        FreeAndNil(StringStream);
        ResultData := TReplyOK;
       End
      Else
       Begin
        vDataPack := StringStream.DataString;
        If not vThreadRequest Then
         Begin
          {$IFNDEF FPC}
           {$IF CompilerVersion > 21}
            StringStream.Clear;
           {$IFEND}
           StringStream.Size := 0;
          {$ENDIF}
          FreeAndNil(StringStream);
          If BinaryRequest Then
           Begin
            If Pos(TReplyNOK, vDataPack) > 0 Then
             SetData(vDataPack, Params, ResultData)
            Else
             ResultData := vDataPack
           End
          Else
           SetData(vDataPack, Params, ResultData);
         End
        Else
         Begin
          {$IFNDEF FPC}
           {$IF CompilerVersion > 21}
           StringStream.Clear;
           {$IFEND}
          StringStream.Size := 0;
          {$ENDIF}
          FreeAndNil(StringStream);
          If BinaryRequest Then
           ResultData := vDataPack
          Else
           SetData(vDataPack, Params, SResult);
          If Assigned(CallBack) Then
           CallBack(SResult, Params);
         End;
       End;
     End;
   End;
  Except
   On E : EIdHTTPProtocolException Do
    Begin
     Result := False;
     ResultData := '';
     vErrorMessage := HttpRequest.ResponseText;
     If Pos(Uppercase(cInvalidInternalError), Uppercase(vErrorMessage)) = 0 Then
      Begin
       While Pos(' ', vErrorMessage) > 0 Do
        Begin
         Delete(vErrorMessage, 1, Pos(' ', vErrorMessage));
         vErrorMessage := Trim(vErrorMessage);
        End;
       vErrorMessage := Trim(vErrorMessage);
       If Not((e.ErrorCode >= 400)  And
              (e.ErrorCode <= 404)) Then
        vErrorMessage := DecodeStrings(vErrorMessage{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
      End;
     If e.ErrorCode = 405 Then
      vErrorMessage := cInvalidPoolerName;
     {Todo: Acrescentado}
     HttpRequest.Disconnect;
     If Assigned(MemoryStream) Then
      FreeAndNil(MemoryStream);
     If Assigned(aStringStream) Then
      FreeAndNil(aStringStream);
     If Assigned(SendParams) then
      FreeAndNil(SendParams);
     //Alexandre Magno - 24/11/2018
     If Assigned(vResultParams) then
      FreeAndNil(vResultParams);
     //Alexandre Magno - 24/11/2018
     If Assigned(StringStreamList) Then
      FreeAndNil(StringStreamList);
     If Assigned(StringStream) then
      FreeAndNil(StringStream);
     If Assigned(aStringStream) then
      FreeAndNil(aStringStream);
     If Not vFailOver then
      Begin
      {$IFNDEF FPC}
       {$IF Defined(HAS_FMX)}
        ErrorMessage := vErrorMessage;
       {$ELSE}
        Raise Exception.Create(vErrorMessage);
       {$IFEND}
      {$ELSE}
       Raise Exception.Create(vErrorMessage);
      {$ENDIF}
      End
     Else
      ErrorMessage := vErrorMessage;
    End;
   On E : Exception Do
    Begin
     Result := False;
     If Not vThreadRequest Then
      ResultData := GetPairJSON('NOK', cPoolerNotFound)
     Else
      Begin
       SResult := GetPairJSON('NOK', cPoolerNotFound);
       If Assigned(CallBack) Then
        CallBack(SResult, Params);
      End;
     {Todo: Acrescentado}
     HttpRequest.Disconnect;
     If Assigned(SendParams) then
      FreeAndNil(SendParams);
     //Alexandre Magno - 24/11/2018
     If Assigned(vResultParams) then
      FreeAndNil(vResultParams);
     //Alexandre Magno - 24/11/2018
     If Assigned(StringStreamList) Then
      FreeAndNil(StringStreamList);
     If Assigned(StringStream) then
      FreeAndNil(StringStream);
     If Assigned(aStringStream) then
      FreeAndNil(aStringStream);
     If Assigned(MemoryStream) Then
      FreeAndNil(MemoryStream);
     If Not vFailOver then
      Begin
      {$IFNDEF FPC}
       {$IF Defined(HAS_FMX)}
        ErrorMessage := cPoolerNotFound;
       {$ELSE}
        Raise Exception.Create(cPoolerNotFound);
       {$IFEND}
      {$ELSE}
       Raise Exception.Create(cPoolerNotFound);
      {$ENDIF}
      End
     Else
      ErrorMessage := e.Message;
    End;
  End;
  If Assigned(vResultParams) Then
   FreeAndNil(vResultParams);
  If Assigned(SendParams) then
   FreeAndNil(SendParams);
  If Assigned(StringStream) then
   FreeAndNil(StringStream);
  If Assigned(MemoryStream) then
   FreeAndNil(MemoryStream);
  If Assigned(aStringStream) Then
   FreeAndNil(aStringStream);
  If Assigned(MemoryStream) Then
   FreeAndNil(MemoryStream);
 End;
Begin
 vDWParam         := Nil;
 MemoryStream     := Nil;
 vResultParams    := Nil;
 aStringStream    := Nil;
 bStringStream    := Nil;
 JSONValue        := Nil;
 SendParams       := Nil;
 StringStreamList := Nil;
 StringStream     := Nil;
 aStringStream    := Nil;
 vResultParams    := Nil;
 aBinaryRequest   := False;
 aBinaryCompatibleMode := False;
 If (Params.ItemsString['BinaryRequest'] <> Nil) Then
  aBinaryRequest  := Params.ItemsString['BinaryRequest'].AsBoolean;
 If (Params.ItemsString['BinaryCompatibleMode'] <> Nil) Then
  aBinaryCompatibleMode := Params.ItemsString['BinaryCompatibleMode'].AsBoolean And aBinaryRequest;
 if Not aBinaryRequest then
  aBinaryRequest  := vBinaryRequest;
 vURL  := BuildUrl(vTypeRequest, vHost, vUrlPath, vPort); //LowerCase(Format(UrlBase, [vTpRequest, vHost, vPort, vUrlPath])) + EventData;
 If Not Assigned(LHandler)  And
   (vTypeRequest = trHttps) Then
  Begin
   LHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
   HttpRequest.IOHandler := LHandler;
  End;
 SetCharsetRequest(HttpRequest, vRSCharset);
 SetParams(HttpRequest, vAuthentication, vUserName, vPassword, vTransparentProxy, vRequestTimeout);
 HttpRequest.MaxAuthRetries := 0;
 If vBinaryRequest Then
  If HttpRequest.Request.CustomHeaders.IndexOfName('binaryrequest') = -1 Then
   HttpRequest.Request.CustomHeaders.AddValue('binaryrequest', 'true');
 If aBinaryCompatibleMode Then
  If HttpRequest.Request.CustomHeaders.IndexOfName('BinaryCompatibleMode') = -1 Then
   HttpRequest.Request.CustomHeaders.AddValue('BinaryCompatibleMode', 'true');
 vErrorMessage              := '';
 Try
  If Not ExecRequest(EventType, vURL, vWelcomeMessage, vAccessTag, vRSCharset, vDatacompress, vEncodeStrings, aBinaryRequest, Result, vErrorMessage) Then
   Begin
    If vFailOver Then
     Begin
      For I := 0 To vFailOverConnections.Count -1 Do
       Begin
        If I = 0 Then
         Begin
          If ((vFailOverConnections[I].vTypeRequest    = vTypeRequest)    And
              (vFailOverConnections[I].vWelcomeMessage = vWelcomeMessage) And
              (vFailOverConnections[I].vRestWebService = vHost)           And
              (vFailOverConnections[I].vPoolerPort     = vPort)           And
              (vFailOverConnections[I].vCompression    = vDatacompress)   And
              (vFailOverConnections[I].hEncodeStrings  = hEncodeStrings)  And
              (vFailOverConnections[I].Encoding        = vRSCharset)      And
              (vFailOverConnections[I].vAccessTag      = vAccessTag)      And
              (vFailOverConnections[I].Host            = vHost)           And
              (vFailOverConnections[I].vRestURL        = vUrlPath)        And
              (vFailOverConnections[I].vAuthentication = vAuthentication) And
              (vFailOverConnections[I].vLogin          = vUsername)       And
              (vFailOverConnections[I].vPassword       = vPassword))      Or
             (Not (vFailOverConnections[I].Active)) Then
          Continue;
         End;
        If Assigned(vOnFailOverExecute) Then
         vOnFailOverExecute(vFailOverConnections[I]);
        vURL  := BuildUrl(vFailOverConnections[I].vTypeRequest,
                          vFailOverConnections[I].Host,
                          vFailOverConnections[I].vRestURL,
                          vFailOverConnections[I].Port); //LowerCase(Format(UrlBase, [vTpRequest, vHost, vPort, vUrlPath])) + EventData;
        SetCharsetRequest(HttpRequest, vFailOverConnections[I].Encoding);
        SetParams(HttpRequest,
                  vFailOverConnections[I].vAuthentication,
                  vFailOverConnections[I].vLogin,
                  vFailOverConnections[I].Password,
                  vFailOverConnections[I].vTransparentProxy,
                  vFailOverConnections[I].vTimeOut);
        If ExecRequest(EventType, vURL,
                       vFailOverConnections[I].vWelcomeMessage,
                       vFailOverConnections[I].vAccessTag,
                       vFailOverConnections[I].Encoding,
                       vFailOverConnections[I].vCompression,
                       vFailOverConnections[I].hEncodeStrings,
                       vBinaryRequest,
                       Result, vErrorMessage) Then
         Begin
          If vFailOverReplaceDefaults Then
           Begin
            vTypeRequest    := vFailOverConnections[I].vTypeRequest;
            vWelcomeMessage := vFailOverConnections[I].WelcomeMessage;
            vHost           := vFailOverConnections[I].Host;
            vPort           := vFailOverConnections[I].Port;
            vDatacompress   := vFailOverConnections[I].vCompression;
            vEncodeStrings  := vFailOverConnections[I].hEncodeStrings;
            vRSCharset      := vFailOverConnections[I].Encoding;
            vAccessTag      := vFailOverConnections[I].AccessTag;
            vUrlPath        := vFailOverConnections[I].vRestURL;
            vRequestTimeout := vFailOverConnections[I].vTimeOut;
            vUsername       := vFailOverConnections[I].vLogin;
            vPassword       := vFailOverConnections[I].vPassword;
           End;
          Break;
         End
        Else
         Begin
          If Assigned(vOnFailOverError) Then
           Begin
            vOnFailOverError(vFailOverConnections[I], vErrorMessage);
            vErrorMessage := '';
           End;
         End;
       End;
     End;
   End;
 Finally
  vThreadExecuting := False;
  If (vErrorMessage <> '') Then
   Result := vErrorMessage;
  If vFailOver Then
   If vErrorMessage <> '' Then
    Raise Exception.Create(Result);
 End;
End;

Function  TRESTDWConnectionServerCP.GetDisplayName             : String;
Begin
 Result := vListName;
End;

Function  TRESTDWConnectionServerCP.GetPoolerList : TStringList;
Var
 I                : Integer;
 vTempList        : TStringList;
 RESTClientPooler : TRESTClientPooler;
 vConnection      : TDWPoolerMethodClient;
Begin
 Result := Nil;
 RESTClientPooler := TRESTClientPooler.Create(Nil);
 Try
  vConnection                := TDWPoolerMethodClient.Create(Nil);
  vConnection.WelcomeMessage := vWelcomeMessage;
  vConnection.Host           := vRestWebService;
  vConnection.Port           := vPoolerPort;
  vConnection.Compression    := vCompression;
  vConnection.TypeRequest    := vTypeRequest;
  vConnection.AccessTag      := vAccessTag;
  Result := TStringList.Create;
  Try
   vTempList := vConnection.GetServerEvents(vRestURL, vTimeOut, vLogin, vPassword);
   Try
    For I := 0 To vTempList.Count -1 do
     Result.Add(vTempList[I]);
   Finally
    If Assigned(vTempList) Then
     vTempList.Free;
   End;
  Except
   On E : Exception do
    Begin
     Raise Exception.Create(cInvalidRDWServer);
    End;
  End;
  FreeAndNil(vConnection);
 Finally
  FreeAndNil(RESTClientPooler);
 End;
End;

Procedure TRESTDWConnectionServerCP.SetDisplayName(Const Value : String);
Begin
 If Trim(Value) = '' Then
  Raise Exception.Create(cInvalidConnectionName)
 Else
  Begin
   vListName := Trim(Value);
   Inherited;
  End;
End;

Destructor TRESTDWConnectionServerCP.Destroy;
Begin
 FreeAndNil(vTransparentProxy);
 Inherited;
End;

Constructor TRESTDWConnectionServerCP.Create(aCollection: TCollection);
Begin
 Inherited;
 {$IFNDEF FPC}
 {$IF CompilerVersion > 21}
  vEncoding         := esUtf8;
 {$ELSE}
  vEncoding         := esAscii;
 {$IFEND}
 {$ELSE}
  vEncoding         := esUtf8;
  vDatabaseCharSet  := csUndefined;
 {$ENDIF}
 vListName          :=  Format('server(%d)', [aCollection.Count]);
 vLogin             := 'testserver';
 vRestWebService    := '127.0.0.1';
 vCompression       := True;
 vAuthentication    := True;
 vPassword          := vLogin;
 vPoolerPort        := 8082;
 vEncodeStrings     := True;
 vTransparentProxy  := TIdProxyConnectionInfo.Create;
 vTimeOut           := 10000;
 vActive            := True;
 vServerEventName   := '';
End;

Function TFailOverConnections.GetOwner: TPersistent;
Begin
 Result:= fOwner;
End;

Function TFailOverConnections.GetRec(Index : Integer) : TRESTDWConnectionServerCP;
Begin
 Result := TRESTDWConnectionServerCP(Inherited GetItem(Index));
End;

Procedure TFailOverConnections.PutRec(Index: Integer; Item: TRESTDWConnectionServerCP);
Begin
 If (Index < Self.Count) And (Index > -1) Then
  SetItem(Index, Item);
End;

Function  TFailOverConnections.GetRecName(Index : String)  : TRESTDWConnectionServerCP;
Var
 I : Integer;
Begin
 Result := Nil;
 For I := 0 To Self.Count - 1 Do
  Begin
   If (Uppercase(Index) = Uppercase(Self.Items[I].vListName)) Then
    Begin
     Result := TRESTDWConnectionServerCP(Self.Items[I]);
     Break;
    End;
  End;
End;

Procedure TFailOverConnections.PutRecName(Index        : String;
                                          Item         : TRESTDWConnectionServerCP);
Var
 I : Integer;
Begin
 For I := 0 To Self.Count - 1 Do
  Begin
   If (Uppercase(Index) = Uppercase(Self.Items[I].vListName)) Then
    Begin
     Self.Items[I] := Item;
     Break;
    End;
  End;
End;

Procedure TFailOverConnections.ClearList;
Var
 I      : Integer;
Begin
 Try
  For I := Count - 1 Downto 0 Do
   Delete(I);
 Finally
  Self.Clear;
 End;
End;

Constructor TFailOverConnections.Create(AOwner      : TPersistent;
                                        aItemClass  : TCollectionItemClass);
Begin
 Inherited Create(AOwner, TRESTDWConnectionServerCP);
 fOwner  := AOwner;
End;

Function TFailOverConnections.Add: TCollectionItem;
Begin
 Result := TRESTDWConnectionServerCP(Inherited Add);
End;

Destructor TFailOverConnections.Destroy;
Begin
 ClearList;
 Inherited;
End;

Procedure TFailOverConnections.Delete(Index : Integer);
Begin
 If (Index < Self.Count) And (Index > -1) Then
  TOwnedCollection(Self).Delete(Index);
End;

Procedure TFailOverConnections.Delete(Index : String);
Begin
 If ItemsByName[Index] <> Nil Then
  TOwnedCollection(Self).Delete(ItemsByName[Index].Index);
End;

Function TRESTClientPooler.SendEvent(EventData : String) : String;
Var
 Params : TDWParams;
Begin
 Try
  Params := Nil;
  Result := SendEvent(EventData, Params);
 Finally
 End;
End;

Procedure TRESTClientPooler.SetAccessTag(Value : String);
Begin
 vAccessTag := Value;
End;

Procedure TRESTClientPooler.SetAllowCookies(Value: Boolean);
Begin
 HttpRequest.AllowCookies    := Value;
End;

Procedure TRESTClientPooler.SetHandleRedirects(Value: Boolean);
Begin
 HttpRequest.HandleRedirects := Value;
End;

Procedure TRESTClientPooler.SetOnStatus(Value : TOnStatus);
Begin
 {$IFDEF FPC}
  vOnStatus            := Value;
  HttpRequest.OnStatus := vOnStatus;
 {$ELSE}
  vOnStatus            := Value;
  HttpRequest.OnStatus := vOnStatus;
 {$ENDIF}
End;

Procedure TRESTClientPooler.SetOnWork(Value : TOnWork);
Begin
 {$IFDEF FPC}
  vOnWork            := Value;
  HttpRequest.OnWork := vOnWork;
 {$ELSE}
  vOnWork            := Value;
  HttpRequest.OnWork := vOnWork;
 {$ENDIF}
End;

Procedure TRESTClientPooler.SetOnWorkBegin(Value : TOnWorkBegin);
Begin
 {$IFDEF FPC}
  vOnWorkBegin            := Value;
  HttpRequest.OnWorkBegin := vOnWorkBegin;
 {$ELSE}
  vOnWorkBegin            := Value;
  HttpRequest.OnWorkBegin := vOnWorkBegin;
 {$ENDIF}
End;

Procedure TRESTClientPooler.SetOnWorkEnd(Value : TOnWorkEnd);
Begin
 {$IFDEF FPC}
  vOnWorkEnd            := Value;
  HttpRequest.OnWorkEnd := vOnWorkEnd;
 {$ELSE}
  vOnWorkEnd            := Value;
  HttpRequest.OnWorkEnd := vOnWorkEnd;
 {$ENDIF}
End;

Procedure TRESTClientPooler.SetParams(Var aHttpRequest  : TIdHTTP;
                                      Authentication    : Boolean;
                                      UserName,
                                      Password          : String;
                                      TransparentProxy  : TIdProxyConnectionInfo;
                                      RequestTimeout    : Integer);
Begin
 aHttpRequest.Request.BasicAuthentication := Authentication;
 If aHttpRequest.Request.BasicAuthentication Then
  Begin
   If aHttpRequest.Request.Authentication = Nil Then
    aHttpRequest.Request.Authentication         := TIdBasicAuthentication.Create;
   aHttpRequest.Request.Authentication.Password := Password;
   aHttpRequest.Request.Authentication.Username := UserName;
  End;
 aHttpRequest.ProxyParams.BasicAuthentication := TransparentProxy.BasicAuthentication;
 aHttpRequest.ProxyParams.ProxyUsername       := TransparentProxy.ProxyUsername;
 aHttpRequest.ProxyParams.ProxyServer         := TransparentProxy.ProxyServer;
 aHttpRequest.ProxyParams.ProxyPassword       := TransparentProxy.ProxyPassword;
 aHttpRequest.ProxyParams.ProxyPort           := TransparentProxy.ProxyPort;
 aHttpRequest.ReadTimeout                     := RequestTimeout;
 aHttpRequest.Request.ContentType             := HttpRequest.Request.ContentType;
 aHttpRequest.AllowCookies                    := HttpRequest.AllowCookies;
 aHttpRequest.HandleRedirects                 := HttpRequest.HandleRedirects;
 aHttpRequest.HTTPOptions                     := HttpRequest.HTTPOptions;
 aHttpRequest.Request.Charset                 := HttpRequest.Request.Charset;
End;

procedure TRESTClientPooler.SetPassword(Value : String);
begin
 vPassword := Value;
 HttpRequest.Request.Password := vPassword;
end;

Procedure TRESTClientPooler.SetUrlPath(Value : String);
Begin
 vUrlPath := Value;
 If Length(vUrlPath) > 0 Then
  If vUrlPath[Length(vUrlPath)] <> '/' Then
   vUrlPath := vUrlPath + '/';
End;

procedure TRESTClientPooler.SetUserName(Value : String);
begin
 vUsername := Value;
 HttpRequest.Request.Username := vUsername;
end;

Destructor  TServerTokenOptions.Destroy;
Begin
 FreeAndNil(vTokenValue);
 Inherited;
End;

Class Function TTokenValue.GetMD5(Const Value : String) : String;
Var
 idmd5   :  TIdHashMessageDigest5;
Begin
 idmd5   := TIdHashMessageDigest5.Create;
 Try
  Result := idmd5.HashStringAsHex(Value);
 Finally
  FreeAndNil(idmd5);
 End;
End;

Class Function TTokenValue.ISO8601FromDateTime(Value : TDateTime) : String;
Begin
 Result := FormatDateTime('yyyy-mm-dd"T"hh":"nn":"ss', Value);
End;

Class Function TTokenValue.DateTimeFromISO8601(Value : String)    : TDateTime;
 Function ExtractNum(Value  : String;
                     a, len : Integer) : Integer;
 Begin
  Result := StrToIntDef(Copy(Value, a, len), 0);
 End;
 Function ISO8601StrToTime(Const S : String) : TDateTime;
 Begin
  If (Length(s) >= 8) And
         (s[3] = ':') Then
   Result := EncodeTime(ExtractNum(s, 1, 2),
                        ExtractNum(s, 4, 2),
                        ExtractNum(s, 7, 2), 0)
  Else
   Result := 0.0;
 End;
Var
 year,
 month,
 day   : Integer;
Begin
 If (Length(Value) >= 10) And
         (Value[5] = '-') And
         (Value[8] = '-') Then
  Begin
   year  := ExtractNum(Value, 1, 4);
   month := ExtractNum(Value, 6, 2);
   day   := ExtractNum(Value, 9, 2);
   If (year = 0)  And
      (month = 0) And
      (day = 0)   Then
    Result := 0.0
   Else
    Result := EncodeDate(year, month, day);
   If (Length(Value) > 10) And
         (Value[11] = 'T') Then
    Result := Result + ISO8601StrToTime(Copy(Value, 12, Length(Value)));
  End
 Else
  Result := ISO8601StrToTime(Value);
End;

Procedure   TTokenValue.SetTokenHash(Token : String);
Begin
 vTokenHash  := Token;
 vCripto.Key := vTokenHash;
End;

Constructor TTokenValue.Create;
Begin
 vCripto := TCripto.Create;
End;

Procedure   TTokenValue.FromToken(Value : String);
Begin

End;

Function    TTokenValue.ToToken : String;
Begin
 Result := '';
End;

Destructor  TTokenValue.Destroy;
Begin
 FreeAndNil(vCripto);
 Inherited;
End;

Destructor  TClientTokenOptions.Destroy;
Begin
 FreeAndNil(vTokenValue);
 Inherited;
End;

Constructor TClientTokenOptions.Create;
Begin
 Inherited;
 vActive        := False;
 vTokenHash     := 'RDWTS_HASH';
 vTokenValue    := TTokenValue.Create;
End;

Procedure   TClientTokenOptions.FromToken(Value : String);
Begin

End;

Procedure   TClientTokenOptions.Assign(Source : TPersistent);
Var
 Src : TClientTokenOptions;
Begin
 If Source is TClientTokenOptions Then
  Begin
   Src       := TClientTokenOptions(Source);
   vActive   := Src.Active;
   vTokenID  := Src.TokenID;
   TokenHash := Src.TokenHash;
  End
 Else
  Inherited;
End;

Procedure   TClientTokenOptions.SetTokenHash(Token : String);
Begin
 vTokenHash            := Token;
 vTokenValue.TokenHash := vTokenHash;
End;

Procedure   TServerTokenOptions.SetTokenHash(Token : String);
Begin
 vTokenHash            := Token;
 vTokenValue.TokenHash := vTokenHash;
End;

Constructor TServerTokenOptions.Create;
Begin
 Inherited;
 vActive        := False;
 vTokenHash     := 'RDWTS_HASH';
 vServerRequest := 'RESTDWServer01';
 vLifeCycle     := 30;
 vTokenValue    := TTokenValue.Create;
End;

Procedure   TServerTokenOptions.Assign(Source : TPersistent);
Var
 Src : TServerTokenOptions;
Begin
 If Source is TServerTokenOptions Then
  Begin
   Src        := TServerTokenOptions(Source);
   vActive    := Src.Active;
   TokenHash  := Src.TokenHash;
   vLifeCycle := Src.LifeCycle;
  End
 Else
  Inherited;
End;

Constructor TProxyOptions.Create;
Begin
 Inherited;
 vServer   := '';
 vLogin    := vServer;
 vPassword := vLogin;
 vPort     := 8888;
End;

Procedure TProxyOptions.Assign(Source: TPersistent);
Var
 Src : TProxyOptions;
Begin
 If Source is TProxyOptions Then
  Begin
   Src := TProxyOptions(Source);
   vServer := Src.Server;
   vLogin  := Src.Login;
   vPassword := Src.Password;
   vPort     := Src.Port;
  End
 Else
  Inherited;
End;

Procedure TRESTServicePooler.GetServerEventsList(ServerMethodsClass   : TComponent;
                                                 Var ServerEventsList : String;
                                                 AccessTag            : String);
Var
 I : Integer;
Begin
 If ServerMethodsClass <> Nil Then
  Begin
   For I := 0 To ServerMethodsClass.ComponentCount -1 Do
    Begin
     If ServerMethodsClass.Components[i] is TDWServerEvents Then
      Begin
       If Trim(TDWServerEvents(ServerMethodsClass.Components[i]).AccessTag) <> '' Then
        Begin
         If TDWServerEvents(ServerMethodsClass.Components[i]).AccessTag <> AccessTag Then
          Continue;
        End;
       If ServerEventsList = '' then
        ServerEventsList := Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name])
       Else
        ServerEventsList := ServerEventsList + '|' + Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name]);
      End;
    End;
  End;
End;

Procedure TRESTServicePooler.GetTableNames(ServerMethodsClass   : TComponent;
                                           Var Pooler           : String;
                                           Var DWParams         : TDWParams;
                                           ConnectionDefs       : TConnectionDefs;
                                           hEncodeStrings       : Boolean;
                                           AccessTag            : String);
Var
 I             : Integer;
 vError        : Boolean;
 vMessageError : String;
 vStrings      : TStringList;
Begin
 If ServerMethodsClass <> Nil Then
  Begin
   For I := 0 To ServerMethodsClass.ComponentCount -1 Do
    Begin
     If ServerMethodsClass.Components[i] is TRESTDWPoolerDB Then
      Begin
       If UpperCase(Pooler) = UpperCase(Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name])) then
        Begin
         If Trim(TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag) <> '' Then
          Begin
           If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag <> AccessTag Then
            Begin
             DWParams.ItemsString['MessageError'].AsString := 'Invalid Access tag...';
             DWParams.ItemsString['Error'].AsBoolean       := True;
             Exit;
            End;
          End;
         If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver <> Nil Then
          Begin
           vError   := DWParams.ItemsString['Error'].AsBoolean;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.Encoding          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).Encoding;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.EncodeStringsJSON := hEncodeStrings;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsEmpty2Null    := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsEmpty2Null;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim2Len      := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim2Len;
//           vStrings := TStringList.Create;
           Try
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.PrepareConnection(ConnectionDefs);
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.GetTableNames(vStrings, vError, vMessageError);
            If DWParams.ItemsString['Result'] <> Nil Then
             Begin
              DWParams.ItemsString['Result'].CriptOptions.Use := False;
              DWParams.ItemsString['Result'].SetValue(vStrings.Text, DWParams.ItemsString['Result'].Encoded);
             End;
           Except
            On E : Exception Do
             Begin
              vMessageError := e.Message;
              vError := True;
             End;
           End;
           FreeAndNil(vStrings);
           If vMessageError <> '' Then
            Begin
             DWParams.ItemsString['MessageError'].CriptOptions.Use := False;
             DWParams.ItemsString['MessageError'].AsString := EncodeStrings(vMessageError{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
            End;
           DWParams.ItemsString['Error'].AsBoolean := vError;
          End;
         Break;
        End;
      End;
    End;
  End;
End;

Procedure TRESTServicePooler.GetKeyFieldNames(ServerMethodsClass      : TComponent;
                                              Var Pooler              : String;
                                              Var DWParams            : TDWParams;
                                              ConnectionDefs          : TConnectionDefs;
                                              hEncodeStrings          : Boolean;
                                              AccessTag               : String);
Var
 I             : Integer;
 vError        : Boolean;
 vTableName,
 vMessageError : String;
 vStrings      : TStringList;
Begin
 If ServerMethodsClass <> Nil Then
  Begin
   For I := 0 To ServerMethodsClass.ComponentCount -1 Do
    Begin
     If ServerMethodsClass.Components[i] is TRESTDWPoolerDB Then
      Begin
       If UpperCase(Pooler) = UpperCase(Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name])) then
        Begin
         If Trim(TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag) <> '' Then
          Begin
           If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag <> AccessTag Then
            Begin
             DWParams.ItemsString['MessageError'].AsString := 'Invalid Access tag...';
             DWParams.ItemsString['Error'].AsBoolean       := True;
             Exit;
            End;
          End;
         If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver <> Nil Then
          Begin
           vError   := DWParams.ItemsString['Error'].AsBoolean;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.Encoding          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).Encoding;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.EncodeStringsJSON := hEncodeStrings;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsEmpty2Null    := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsEmpty2Null;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim2Len      := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim2Len;
//           vStrings := TStringList.Create;
           Try
            DWParams.ItemsString['TableName'].CriptOptions.Use := False;
            vTableName := DWParams.ItemsString['TableName'].AsString;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.PrepareConnection(ConnectionDefs);
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.GetKeyFieldNames(vTableName, vStrings, vError, vMessageError);
            If DWParams.ItemsString['Result'] <> Nil Then
             Begin
              DWParams.ItemsString['Result'].CriptOptions.Use := False;
              DWParams.ItemsString['Result'].SetValue(vStrings.Text, DWParams.ItemsString['Result'].Encoded);
             End;
           Except
            On E : Exception Do
             Begin
              vMessageError := e.Message;
              vError := True;
             End;
           End;
           FreeAndNil(vStrings);
           If vMessageError <> '' Then
            Begin
             DWParams.ItemsString['MessageError'].CriptOptions.Use := False;
             DWParams.ItemsString['MessageError'].AsString := EncodeStrings(vMessageError{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
            End;
           DWParams.ItemsString['Error'].AsBoolean := vError;
          End;
         Break;
        End;
      End;
    End;
  End;
End;

Procedure TRESTServicePooler.GetFieldNames(ServerMethodsClass   : TComponent;
                                           Var Pooler           : String;
                                           Var DWParams         : TDWParams;
                                           ConnectionDefs       : TConnectionDefs;
                                           hEncodeStrings       : Boolean;
                                           AccessTag            : String);
Var
 I             : Integer;
 vError        : Boolean;
 vTableName,
 vMessageError : String;
 vStrings      : TStringList;
Begin
 If ServerMethodsClass <> Nil Then
  Begin
   For I := 0 To ServerMethodsClass.ComponentCount -1 Do
    Begin
     If ServerMethodsClass.Components[i] is TRESTDWPoolerDB Then
      Begin
       If UpperCase(Pooler) = UpperCase(Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name])) then
        Begin
         If Trim(TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag) <> '' Then
          Begin
           If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag <> AccessTag Then
            Begin
             DWParams.ItemsString['MessageError'].AsString := 'Invalid Access tag...';
             DWParams.ItemsString['Error'].AsBoolean       := True;
             Exit;
            End;
          End;
         If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver <> Nil Then
          Begin
           vError   := DWParams.ItemsString['Error'].AsBoolean;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.Encoding          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).Encoding;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.EncodeStringsJSON := hEncodeStrings;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsEmpty2Null    := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsEmpty2Null;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim2Len      := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim2Len;
//           vStrings := TStringList.Create;
           Try
            DWParams.ItemsString['TableName'].CriptOptions.Use := False;
            vTableName := DWParams.ItemsString['TableName'].AsString;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.PrepareConnection(ConnectionDefs);
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.GetFieldNames(vTableName, vStrings, vError, vMessageError);
            If DWParams.ItemsString['Result'] <> Nil Then
             Begin
              DWParams.ItemsString['Result'].CriptOptions.Use := False;
              DWParams.ItemsString['Result'].SetValue(vStrings.Text, DWParams.ItemsString['Result'].Encoded);
             End;
           Except
            On E : Exception Do
             Begin
              vMessageError := e.Message;
              vError := True;
             End;
           End;
           FreeAndNil(vStrings);
           If vMessageError <> '' Then
            Begin
             DWParams.ItemsString['MessageError'].CriptOptions.Use := False;
             DWParams.ItemsString['MessageError'].AsString := EncodeStrings(vMessageError{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
            End;
           DWParams.ItemsString['Error'].AsBoolean := vError;
          End;
         Break;
        End;
      End;
    End;
  End;
End;

Procedure TRESTServicePooler.GetPoolerList(ServerMethodsClass : TComponent;
                                           Var PoolerList     : String;
                                           AccessTag          : String);
Var
 I : Integer;
Begin
 If ServerMethodsClass <> Nil Then
  Begin
   For I := 0 To ServerMethodsClass.ComponentCount -1 Do
    Begin
     If ServerMethodsClass.Components[i] is TRESTDWPoolerDB Then
      Begin
       If Trim(TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag) <> '' Then
        Begin
         If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag <> AccessTag Then
          Continue;
        End;
       If PoolerList = '' then
        PoolerList := Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name])
       Else
        PoolerList := PoolerList + '|' + Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name]);
      End;
    End;
  End;
End;

Procedure TRESTServicePooler.EchoPooler(ServerMethodsClass : TComponent;
                                        AContext           : TIdContext;
                                        Var Pooler,
                                            MyIP           : String;
                                        AccessTag          : String;
                                        Var InvalidTag     : Boolean);
Var
 I : Integer;
Begin
 InvalidTag := False;
 MyIP       := '';
 If ServerMethodsClass <> Nil Then
  Begin
   For I := 0 To ServerMethodsClass.ComponentCount -1 Do
    Begin
     If (ServerMethodsClass.Components[i] is TRESTDWPoolerDB) Then
      Begin
       If Pooler = Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name]) Then
        Begin
         If Trim(TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag) <> '' Then
          Begin
           If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag <> AccessTag Then
            Begin
             InvalidTag := True;
             Exit;
            End;
          End;
         If AContext <> Nil Then
          MyIP := AContext.Connection.Socket.Binding.PeerIP;
         Break;
        End;
      End;
    End;
  End;
End;

Procedure TRESTServicePooler.ExecuteCommandPureJSON(ServerMethodsClass   : TComponent;
                                                    Var Pooler           : String;
                                                    Var DWParams         : TDWParams;
                                                    ConnectionDefs       : TConnectionDefs;
                                                    hEncodeStrings       : Boolean;
                                                    AccessTag            : String;
                                                    BinaryEvent          : Boolean;
                                                    Metadata             : Boolean;
                                                    BinaryCompatibleMode : Boolean);
Var
 vRowsAffected,
 I             : Integer;
 vEncoded,
 vError,
 vExecute      : Boolean;
 vTempJSON,
 vMessageError : String;
 BinaryBlob    : TMemoryStream;
Begin
 vRowsAffected := 0;
 BinaryBlob    := Nil;
 Try
  vTempJSON := '';
  If ServerMethodsClass <> Nil Then
   Begin
    For I := 0 To ServerMethodsClass.ComponentCount -1 Do
     Begin
      If ServerMethodsClass.Components[i] is TRESTDWPoolerDB Then
       Begin
        If UpperCase(Pooler) = UpperCase(Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name])) then
         Begin
          If Trim(TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag) <> '' Then
           Begin
            If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag <> AccessTag Then
             Begin
              DWParams.ItemsString['MessageError'].AsString := 'Invalid Access tag...';
              DWParams.ItemsString['Error'].AsBoolean       := True;
              Exit;
             End;
           End;
          If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver <> Nil Then
           Begin
            vExecute := DWParams.ItemsString['Execute'].AsBoolean;
            vError   := DWParams.ItemsString['Error'].AsBoolean;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.Encoding          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).Encoding;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.EncodeStringsJSON := hEncodeStrings;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsEmpty2Null    := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsEmpty2Null;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim2Len      := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim2Len;
            Try
             TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.PrepareConnection(ConnectionDefs);
             vTempJSON := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.ExecuteCommand(DWParams.ItemsString['SQL'].Value,
                                                                                                      vError,
                                                                                                      vMessageError,
                                                                                                      BinaryBlob,
                                                                                                      vRowsAffected,
                                                                                                      vExecute, BinaryEvent, Metadata,
                                                                                                      BinaryCompatibleMode);
            Except
             On E : Exception Do
              Begin
               vMessageError := e.Message;
               vError := True;
              End;
            End;
            If vMessageError <> '' Then
             Begin
              DWParams.ItemsString['MessageError'].CriptOptions.Use := False;
              DWParams.ItemsString['MessageError'].AsString := EncodeStrings(vMessageError{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
             End;
            DWParams.ItemsString['Error'].AsBoolean := vError;
            If DWParams.ItemsString['RowsAffected'] <> Nil Then
             DWParams.ItemsString['RowsAffected'].AsInteger := vRowsAffected;
            If DWParams.ItemsString['Result'] <> Nil Then
             Begin
              vEncoded := DWParams.ItemsString['Result'].Encoded;
              If (BinaryEvent) And (Not (vError)) Then
               DWParams.ItemsString['Result'].LoadFromStream(BinaryBlob)
              Else If Not(vError) And (vTempJSON <> '') Then
               DWParams.ItemsString['Result'].SetValue(vTempJSON, vEncoded)
              Else
               DWParams.ItemsString['Result'].SetValue('');
             End;
           End;
          Break;
         End;
       End;
     End;
   End;
 Finally
  If Assigned(BinaryBlob) Then
   FreeAndNil(BinaryBlob);
 End;
End;

Procedure TRESTServicePooler.IdHTTPServerQuerySSLPort(APort       : Word;
                                                      var VUseSSL : Boolean);
Begin
 VUseSSL := (APort = Self.ServicePort);
End;

Procedure TRESTServicePooler.InsertMySQLReturnID(ServerMethodsClass : TComponent;
                                                 Var Pooler         : String;
                                                 Var DWParams       : TDWParams;
                                                 ConnectionDefs     : TConnectionDefs;
                                                 hEncodeStrings     : Boolean;
                                                 AccessTag          : String);
Var
 I,
 vTempJSON     : Integer;
 vError        : Boolean;
 vMessageError : String;
 DWParamsD     : TDWParams;
Begin
 DWParamsD := Nil;
 If ServerMethodsClass <> Nil Then
  Begin
   For I := 0 To ServerMethodsClass.ComponentCount -1 Do
    Begin
     If ServerMethodsClass.Components[i] is TRESTDWPoolerDB Then
      Begin
       If UpperCase(Pooler) = UpperCase(Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name])) then
        Begin
         If Trim(TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag) <> '' Then
          Begin
           If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag <> AccessTag Then
            Begin
             DWParams.ItemsString['MessageError'].AsString := 'Invalid Access tag...';
             DWParams.ItemsString['Error'].AsBoolean       := True;
             Exit;
            End;
          End;
         If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver <> Nil Then
          Begin
           vError   := DWParams.ItemsString['Error'].AsBoolean;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.Encoding          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).Encoding;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.EncodeStringsJSON := hEncodeStrings;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsEmpty2Null    := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsEmpty2Null;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim2Len      := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim2Len;
           If DWParams.ItemsString['Params'] <> Nil Then
            Begin
             DWParamsD := TDWParams.Create;
             DWParamsD.FromJSON(DWParams.ItemsString['Params'].Value);
            End;
           Try
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.PrepareConnection(ConnectionDefs);
            If DWParamsD <> Nil Then
             Begin
              vTempJSON := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.InsertMySQLReturnID(DWParams.ItemsString['SQL'].Value,
                                                                                                            DWParamsD, vError, vMessageError);
              DWParamsD.Free;
             End
            Else
             vTempJSON := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.InsertMySQLReturnID(DWParams.ItemsString['SQL'].Value,
                                                                                                           vError,
                                                                                                           vMessageError);
           Except
            On E : Exception Do
             Begin
              vMessageError := e.Message;
              vError := True;
             End;
           End;
           If vMessageError <> '' Then
            Begin
             DWParams.ItemsString['MessageError'].CriptOptions.Use := False;
             DWParams.ItemsString['MessageError'].AsString := EncodeStrings(vMessageError{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
            End;
           DWParams.ItemsString['Error'].AsBoolean := vError;
           If DWParams.ItemsString['Result'] <> Nil Then
            Begin
             If vTempJSON <> -1 Then
              DWParams.ItemsString['Result'].SetValue(IntToStr(vTempJSON), DWParams.ItemsString['Result'].Encoded)
             Else
              DWParams.ItemsString['Result'].SetValue('-1');
            End;
          End;
         Break;
        End;
      End;
    End;
  End;
End;

procedure TRESTServicePooler.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    {$IFNDEF FPC}
     {$IF Defined(HAS_FMX)}
      {$IFDEF WINDOWS}
    if (AComponent = vDWISAPIRunner) then
      vDWISAPIRunner := nil;

    if (AComponent = vDWCGIRunner) then
      vDWCGIRunner := nil;
      {$ENDIF}
     {$IFEND}
    {$ENDIF}

    if (AComponent = vRESTServiceNotification) then
      vRESTServiceNotification := nil;
  end;

  inherited Notification(AComponent, Operation);
end;

Procedure TRESTServicePooler.ProcessMassiveSQLCache(ServerMethodsClass      : TComponent;
                                                    Var Pooler              : String;
                                                    Var DWParams            : TDWParams;
                                                    ConnectionDefs          : TConnectionDefs;
                                                    hEncodeStrings          : Boolean;
                                                    AccessTag               : String);
Var
 I             : Integer;
 vError        : Boolean;
 vMessageError : String;
 vTempJSON     : TJSONValue;
Begin
 If ServerMethodsClass <> Nil Then
  Begin
   For I := 0 To ServerMethodsClass.ComponentCount -1 Do
    Begin
     If ServerMethodsClass.Components[i] is TRESTDWPoolerDB Then
      Begin
       If UpperCase(Pooler) = UpperCase(Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name])) then
        Begin
         If Trim(TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag) <> '' Then
          Begin
           If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag <> AccessTag Then
            Begin
             DWParams.ItemsString['MessageError'].AsString := 'Invalid Access tag...';
             DWParams.ItemsString['Error'].AsBoolean       := True;
             Exit;
            End;
          End;
         If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver <> Nil Then
          Begin
           vError   := DWParams.ItemsString['Error'].AsBoolean;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.Encoding          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).Encoding;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.EncodeStringsJSON := hEncodeStrings;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsEmpty2Null    := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsEmpty2Null;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim2Len      := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim2Len;
           Try
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.PrepareConnection(ConnectionDefs);
            vTempJSON := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.ProcessMassiveSQLCache(DWParams.ItemsString['MassiveSQLCache'].AsString,
                                                                                                   vError,  vMessageError);
           Except
            On E : Exception Do
             Begin
              vMessageError := e.Message;
              vError := True;
             End;
           End;
           If vMessageError <> '' Then
            Begin
             DWParams.ItemsString['MessageError'].CriptOptions.Use := False;
             DWParams.ItemsString['MessageError'].AsString := EncodeStrings(vMessageError{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
            End;
           DWParams.ItemsString['Error'].AsBoolean        := vError;
           If (DWParams.ItemsString['Result'] <> Nil) And Not(vError) Then
            Begin
             If vTempJSON <> Nil Then
              Begin
               DWParams.ItemsString['Result'].SetValue(vTempJSON.Value, DWParams.ItemsString['Result'].Encoded);
               vTempJSON.Free;
              End
             Else
              DWParams.ItemsString['Result'].SetValue('');
            End;
          End;
         Break;
        End;
      End;
    End;
  End;
End;

Procedure TRESTServicePooler.ApplyUpdates_MassiveCache(ServerMethodsClass : TComponent;
                                                       Var Pooler         : String;
                                                       Var DWParams       : TDWParams;
                                                       ConnectionDefs     : TConnectionDefs;
                                                       hEncodeStrings     : Boolean;
                                                       AccessTag          : String);
Var
 I             : Integer;
 vError        : Boolean;
 vMessageError : String;
 vTempJSON     : TJSONValue;
Begin
 If ServerMethodsClass <> Nil Then
  Begin
   For I := 0 To ServerMethodsClass.ComponentCount -1 Do
    Begin
     If ServerMethodsClass.Components[i] is TRESTDWPoolerDB Then
      Begin
       If UpperCase(Pooler) = UpperCase(Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name])) then
        Begin
         If Trim(TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag) <> '' Then
          Begin
           If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag <> AccessTag Then
            Begin
             DWParams.ItemsString['MessageError'].AsString := 'Invalid Access tag...';
             DWParams.ItemsString['Error'].AsBoolean       := True;
             Exit;
            End;
          End;
         If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver <> Nil Then
          Begin
           vError   := DWParams.ItemsString['Error'].AsBoolean;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.Encoding          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).Encoding;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.EncodeStringsJSON := hEncodeStrings;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsEmpty2Null    := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsEmpty2Null;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim2Len      := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim2Len;
           Try
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.PrepareConnection(ConnectionDefs);
//            DWParams.ItemsString['MassiveCache'].CriptOptions.Use := False;
            vTempJSON := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.ApplyUpdates_MassiveCache(DWParams.ItemsString['MassiveCache'].AsString,
                                                                                                   vError,  vMessageError);
           Except
            On E : Exception Do
             Begin
              vMessageError := e.Message;
              vError := True;
             End;
           End;
           If vMessageError <> '' Then
            Begin
             DWParams.ItemsString['MessageError'].CriptOptions.Use := False;
             DWParams.ItemsString['MessageError'].AsString := EncodeStrings(vMessageError{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
            End;
           DWParams.ItemsString['Error'].AsBoolean        := vError;
           If (DWParams.ItemsString['Result'] <> Nil) And Not(vError) Then
            Begin
             If Assigned(vTempJSON) Then
              DWParams.ItemsString['Result'].SetValue(vTempJSON.Value, DWParams.ItemsString['Result'].Encoded)
             Else
              DWParams.ItemsString['Result'].SetValue('');
            End;
          End;
         Break;
        End;
      End;
    End;
  End;
 If Not(vError) Then
  If Assigned(vTempJSON) Then
   FreeAndNil(vTempJSON);
End;

Procedure TRESTServicePooler.ApplyUpdatesJSON(ServerMethodsClass : TComponent;
                                              Var Pooler         : String;
                                              Var DWParams       : TDWParams;
                                              ConnectionDefs     : TConnectionDefs;
                                              hEncodeStrings     : Boolean;
                                              AccessTag          : String);
Var
 vRowsAffected,
 I             : Integer;
 vTempJSON     : TJSONValue;
 vError        : Boolean;
 vSQL,
 vMessageError : String;
 DWParamsD     : TDWParams;
Begin
 DWParamsD := Nil;
 vRowsAffected := 0;
 If ServerMethodsClass <> Nil Then
  Begin
   For I := 0 To ServerMethodsClass.ComponentCount -1 Do
    Begin
     If ServerMethodsClass.Components[i] is TRESTDWPoolerDB Then
      Begin
       If UpperCase(Pooler) = UpperCase(Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name])) then
        Begin
         If Trim(TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag) <> '' Then
          Begin
           If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag <> AccessTag Then
            Begin
             DWParams.ItemsString['MessageError'].AsString := 'Invalid Access tag...';
             DWParams.ItemsString['Error'].AsBoolean       := True;
             Exit;
            End;
          End;
         If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver <> Nil Then
          Begin
           vError   := DWParams.ItemsString['Error'].AsBoolean;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.Encoding          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).Encoding;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.EncodeStringsJSON := hEncodeStrings;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsEmpty2Null    := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsEmpty2Null;
           TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim2Len      := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim2Len;
           If DWParams.ItemsString['Params'] <> Nil Then
            Begin
             DWParamsD := TDWParams.Create;
             DWParamsD.FromJSON(DWParams.ItemsString['Params'].Value);
            End;
           If DWParams.ItemsString['SQL'] <> Nil Then
            vSQL := DWParams.ItemsString['SQL'].Value;
           Try
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.PrepareConnection(ConnectionDefs);
            DWParams.ItemsString['Massive'].CriptOptions.Use := False;
            vTempJSON := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.ApplyUpdates(DWParams.ItemsString['Massive'].AsString,
                                                                                                    vSQL,
                                                                                                    DWParamsD, vError, vMessageError, vRowsAffected);
           Except
            On E : Exception Do
             Begin
              vMessageError := e.Message;
              vError := True;
             End;
           End;
           If DWParamsD <> Nil Then
            DWParamsD.Free;
           If vMessageError <> '' Then
            Begin
             DWParams.ItemsString['MessageError'].CriptOptions.Use := False;
             DWParams.ItemsString['MessageError'].AsString := EncodeStrings(vMessageError{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
            End;
           DWParams.ItemsString['Error'].AsBoolean        := vError;
           If (DWParams.ItemsString['RowsAffected'] <> Nil) Then
            DWParams.ItemsString['RowsAffected'].AsInteger := vRowsAffected;
           If (DWParams.ItemsString['Result'] <> Nil) And Not(vError) Then
            Begin
             DWParams.ItemsString['Result'].CriptOptions.Use := False;
             If vTempJSON <> Nil Then
              DWParams.ItemsString['Result'].SetValue(vTempJSON.ToJSON, DWParams.ItemsString['Result'].Encoded)
             Else
              DWParams.ItemsString['Result'].SetValue('');
            End;
          End;
         Break;
        End;
      End;
    End;
  End;
 If Not(vError) Then
  If Assigned(vTempJSON) Then
   FreeAndNil(vTempJSON);
End;

Procedure TRESTServicePooler.ExecuteCommandJSON(ServerMethodsClass   : TComponent;
                                                Var Pooler           : String;
                                                Var DWParams         : TDWParams;
                                                ConnectionDefs       : TConnectionDefs;
                                                hEncodeStrings       : Boolean;
                                                AccessTag            : String;
                                                BinaryEvent          : Boolean;
                                                Metadata             : Boolean;
                                                BinaryCompatibleMode : Boolean);
Var
 vRowsAffected,
 I             : Integer;
 vError,
 vExecute      : Boolean;
 vTempJSON,
 vMessageError : String;
 DWParamsD     : TDWParams;
 BinaryBlob    : TMemoryStream;
Begin
 DWParamsD     := Nil;
 BinaryBlob    := Nil;
 vTempJSON     := '';
 vRowsAffected := 0;
 Try
  If ServerMethodsClass <> Nil Then
   Begin
    For I := 0 To ServerMethodsClass.ComponentCount -1 Do
     Begin
      If ServerMethodsClass.Components[i] is TRESTDWPoolerDB Then
       Begin
        If UpperCase(Pooler) = UpperCase(Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name])) then
         Begin
          If Trim(TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag) <> '' Then
           Begin
            If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag <> AccessTag Then
             Begin
              DWParams.ItemsString['MessageError'].AsString := 'Invalid Access tag...';
              DWParams.ItemsString['Error'].AsBoolean       := True;
              Exit;
             End;
           End;
          If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver <> Nil Then
           Begin
            vExecute := DWParams.ItemsString['Execute'].AsBoolean;
            vError   := DWParams.ItemsString['Error'].AsBoolean;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.Encoding          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).Encoding;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.EncodeStringsJSON := hEncodeStrings;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsEmpty2Null    := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsEmpty2Null;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim2Len      := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim2Len;
            If DWParams.ItemsString['Params'] <> Nil Then
             Begin
              DWParamsD := TDWParams.Create;
              DWParamsD.FromJSON(DWParams.ItemsString['Params'].Value);
             End;
            Try
             TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.PrepareConnection(ConnectionDefs);
             If DWParamsD <> Nil Then
              Begin
               vTempJSON := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.ExecuteCommand(DWParams.ItemsString['SQL'].Value,
                                                                                                        DWParamsD, vError, vMessageError,
                                                                                                        BinaryBlob,
                                                                                                        vRowsAffected,
                                                                                                        vExecute, BinaryEvent, Metadata,
                                                                                                        BinaryCompatibleMode);
               DWParamsD.Free;
              End
             Else
              vTempJSON := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.ExecuteCommand(DWParams.ItemsString['SQL'].Value,
                                                                                                       vError,
                                                                                                       vMessageError,
                                                                                                       BinaryBlob,
                                                                                                       vRowsAffected,
                                                                                                       vExecute, BinaryEvent, Metadata);
            Except
             On E : Exception Do
              Begin
               vMessageError := e.Message;
               vError := True;
              End;
            End;
            If vMessageError <> '' Then
             Begin
              DWParams.ItemsString['MessageError'].CriptOptions.Use := False;
              DWParams.ItemsString['MessageError'].AsString := EncodeStrings(vMessageError{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
             End;
            DWParams.ItemsString['Error'].AsBoolean        := vError;
            If DWParams.ItemsString['RowsAffected'] <> Nil Then
             DWParams.ItemsString['RowsAffected'].AsInteger := vRowsAffected;
            If DWParams.ItemsString['Result'] <> Nil Then
             Begin
              If (BinaryEvent) And (Not (vError)) Then
               DWParams.ItemsString['Result'].LoadFromStream(BinaryBlob)
              Else If Not(vError) And(vTempJSON <> '') Then
               DWParams.ItemsString['Result'].SetValue(vTempJSON, DWParams.ItemsString['Result'].Encoded)
              Else
               DWParams.ItemsString['Result'].SetValue('');
             End;
           End;
          Break;
         End;
       End;
     End;
   End;
 Finally
  If Assigned(BinaryBlob) Then
   FreeAndNil(BinaryBlob);
 End;
End;

Procedure TRESTServicePooler.SetCORSCustomHeader (Value : TStringList);
Var
 I : Integer;
Begin
 vCORSCustomHeaders.Clear;
 For I := 0 To Value.Count -1 do
  vCORSCustomHeaders.Add(Value[I]);
End;

Procedure TRESTServicePooler.SetDefaultPage (Value : TStringList);
Var
 I : Integer;
Begin
 vDefaultPage.Clear;
 For I := 0 To Value.Count -1 do
  vDefaultPage.Add(Value[I]);
End;

Function TRESTServicePooler.ReturnContext(ServerMethodsClass      : TComponent;
                                          Var Pooler,
                                          vResult,
                                          urlContext,
                                          ContentType             : String;
                                          Var ServerContextStream : TMemoryStream;
                                          Var Error               : Boolean;
                                          Var   DWParams          : TDWParams;
                                          Const RequestType       : TRequestType;
                                          mark                    : String;
                                          RequestHeader           : TStringList;
                                          Var ErrorCode           : Integer) : Boolean;
Var
 I            : Integer;
 vRejected,
 vTagService,
 vDefaultPageB : Boolean;
 vErrorMessage,
 vBaseHeader,
 vRootContext : String;
 vStrAcceptedRoutes: string;
 vDWRoutes: TDWRoutes;
Begin
 Result        := False;
 vDefaultPageB  := False;
 vRejected     := False;
 Error         := False;
 vTagService   := Result;
 vRootContext  := '';
 vErrorMessage := '';
 If (Pooler <> '') And (urlContext = '') Then
  Begin
   urlContext := Pooler;
   Pooler     := '';
  End;
 If ServerMethodsClass <> Nil Then
  Begin
   For I := 0 To ServerMethodsClass.ComponentCount -1 Do
    Begin
     If ServerMethodsClass.Components[i] is TDWServerContext Then
      Begin
       If ((LowerCase(urlContext) = LowerCase(TDWServerContext(ServerMethodsClass.Components[i]).BaseContext))) Or
          ((Trim(TDWServerContext(ServerMethodsClass.Components[i]).BaseContext) = '') And (Pooler = '')        And
           (TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[urlContext] <> Nil))   Then
        Begin
         vRootContext := TDWServerContext(ServerMethodsClass.Components[i]).RootContext;
         If ((Pooler = '')    And (vRootContext <> '')) Then
          Pooler := vRootContext;
         vTagService := TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler] <> Nil;
         If Not vTagService Then
          Begin
           Error   := True;
           vResult := cInvalidRequest;
          End;
        End;
       If vTagService Then
        Begin
         Result   := False;
         If (RequestTypeToRoute(RequestType) In TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].Routes) Or
            (crAll in TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].Routes) Then
          Begin
           If Assigned(TDWServerContext(ServerMethodsClass.Components[i]).OnBeforeRenderer) Then
            TDWServerContext(ServerMethodsClass.Components[i]).OnBeforeRenderer(ServerMethodsClass.Components[i]);
           If Assigned(TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].OnAuthRequest) Then
            TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].OnAuthRequest(DWParams, vRejected, vErrorMessage, ErrorCode, RequestHeader);
           If Not vRejected Then
            Begin
             Result  := True;
             vResult := '';
             TDWServerContext(ServerMethodsClass.Components[i]).CreateDWParams(Pooler, DWParams);
             Try
              ContentType := TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].ContentType;
              If mark <> '' Then
               Begin
                vResult    := '';
                Result     := Assigned(TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].ContextRules);
                If Result Then
                 Begin
                  Result   := TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].ContextRules.Items.MarkByName[mark] <> Nil;
                  If Result Then
                   Begin
                    Result := Assigned(TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].ContextRules.Items.MarkByName[mark].OnRequestExecute);
                    If Result Then
                     Begin
                      ContentType := 'application/json';
                      TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].ContextRules.Items.MarkByName[mark].OnRequestExecute(DWParams, ContentType, vResult);
//                      vResult := utf8Encode(vResult);
                     End;
                   End;
                 End;
               End
              Else If Assigned(TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].ContextRules) Then
               Begin
                vBaseHeader := '';
                ContentType := TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].ContextRules.ContentType;
                vResult := TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].ContextRules.BuildContext(TDWServerContext(ServerMethodsClass.Components[i]).BaseHeader,
                                                                                                                                          TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].IgnoreBaseHeader);
               End
              Else
               Begin
                If Assigned(TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].OnBeforeCall) Then
                 TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].OnBeforeCall(TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler]);
                vDefaultPageB := Not Assigned(TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].OnReplyRequest);
                If Not vDefaultPageB Then
                 TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].OnReplyRequest(DWParams, ContentType, vResult, RequestType);
                If Assigned(TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].OnReplyRequestStream) Then
                 Begin
                  vDefaultPageB := False;
                  ServerContextStream := TMemoryStream.Create;
                  Try
                   TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].OnReplyRequestStream(DWParams, ContentType, ServerContextStream, RequestType, ErrorCode);
                  Finally
                   If ServerContextStream.Size = 0 Then
                    FreeAndNil(ServerContextStream);
                  End;
                 End;
                If vDefaultPageB Then
                 Begin
                  vBaseHeader := '';
                  If Assigned(TDWServerContext(ServerMethodsClass.Components[i]).BaseHeader) Then
                   vBaseHeader := TDWServerContext(ServerMethodsClass.Components[i]).BaseHeader.Text;
                  vResult := TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].DefaultHtml.Text;
                  If Assigned(TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].OnBeforeRenderer) Then
                   TDWServerContext(ServerMethodsClass.Components[i]).ContextList.ContextByName[Pooler].OnBeforeRenderer(vBaseHeader, ContentType, vResult, RequestType);
                 End;
               End;
             Except
              On E : Exception Do
               Begin
                 //Alexandre Magno - 22/01/2019
                If DWParams.ItemsString['dwencodestrings'] <> Nil Then
                 vResult := EncodeStrings(e.Message{$IFDEF FPC}, vDatabaseCharSet{$ENDIF})
                Else
                 vResult := e.Message;
                Error   := True;
                Exit;
               End;
             End;
            End
           Else
            Begin
             If vErrorMessage <> '' Then
              Begin
               ContentType := 'text/html';
               vResult     := vErrorMessage;
              End
             Else
              vResult   := cRequestRejected;
            End;
           If Trim(vResult) = '' Then
            vResult := TReplyOK;
          End
         Else
          Begin
           vStrAcceptedRoutes := '';
           vDWRoutes := TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler].Routes;
           If crGet in vDWRoutes Then
            Begin
             If vStrAcceptedRoutes <> '' Then
              vStrAcceptedRoutes := vStrAcceptedRoutes + ', GET'
             Else
              vStrAcceptedRoutes := 'GET';
            End;
           If crPost in vDWRoutes Then
            Begin
               If vStrAcceptedRoutes <> '' Then
                vStrAcceptedRoutes := vStrAcceptedRoutes + ', POST'
               Else
                vStrAcceptedRoutes := 'POST';
            End;
           If crPut in vDWRoutes Then
            Begin
             If vStrAcceptedRoutes <> '' Then
              vStrAcceptedRoutes := vStrAcceptedRoutes + ', PUT'
             Else
              vStrAcceptedRoutes := 'PUT';
            End;
           If crPatch in vDWRoutes Then
            Begin
             If vStrAcceptedRoutes <> '' Then
              vStrAcceptedRoutes := vStrAcceptedRoutes + ', PATCH'
             Else
              vStrAcceptedRoutes := 'PATCH';
            End;
           If crDelete in vDWRoutes Then
            Begin
             If vStrAcceptedRoutes <> '' Then
              vStrAcceptedRoutes := vStrAcceptedRoutes + ', DELETE'
             Else
              vStrAcceptedRoutes := 'DELETE';
            End;
           If vStrAcceptedRoutes <> '' Then
            Begin
             vResult   := cRequestRejectedMethods + vStrAcceptedRoutes;
             ErrorCode := 403;
            End
           Else
            Begin
             vResult   := cRequestAcceptableMethods;
             ErrorCode := 500;
            End;
          End;
         Break;
        End;
      End;
    End;
  End;
End;

Function TRESTServicePooler.ReturnEvent(ServerMethodsClass : TComponent;
                                        Var Pooler,
                                        vResult,
                                        urlContext          : String;
                                        Var DWParams        : TDWParams;
                                        Var JsonMode        : TJsonMode;
                                        Var ErrorCode       : Integer;
                                        Var ContentType,
                                        AccessTag           : String;
                                        Const RequestType   : TRequestType;
                                        Var   RequestHeader : TStringList) : Boolean;
Var
 I             : Integer;
 vRejected,
 vTagService   : Boolean;
 vErrorMessage : String;
 vStrAcceptedRoutes: string;
 vDWRoutes: TDWRoutes;
Begin
 Result        := False;
 vRejected     := False;
 vTagService   := Result;
 vErrorMessage := '';
 If ServerMethodsClass <> Nil Then
  Begin
   For I := 0 To ServerMethodsClass.ComponentCount -1 Do
    Begin
     If ServerMethodsClass.Components[i] is TDWServerEvents Then
      Begin
       If (LowerCase(urlContext) = LowerCase(TDWServerEvents(ServerMethodsClass.Components[i]).ContextName)) Or
          (LowerCase(urlContext) = LowerCase(ServerMethodsClass.Components[i].Name)) or
          (LowerCase(urlContext) = LowerCase(ServerMethodsClass.classname + '.' +
                                             ServerMethodsClass.Components[i].Name)) Then
        vTagService := TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler] <> Nil;
       If vTagService Then
        Begin
         Result   := True;
         JsonMode := jmPureJSON;
         If Trim(TDWServerEvents(ServerMethodsClass.Components[i]).AccessTag) <> '' Then
          Begin
           If TDWServerEvents(ServerMethodsClass.Components[i]).AccessTag <> AccessTag Then
            Begin
             If DWParams.ItemsString['dwencodestrings'] <> Nil Then
              vResult := EncodeStrings('Invalid Access tag...'{$IFDEF FPC}, vDatabaseCharSet{$ENDIF})
             Else
              vResult := 'Invalid Access tag...';
             ErrorCode := 401;
             Result  := True;
             Break;
            End;
          End;
         If (RequestTypeToRoute(RequestType) In TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler].Routes) Or
            (crAll in TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler].Routes) Then
          Begin
           vResult := '';
           TDWServerEvents(ServerMethodsClass.Components[i]).CreateDWParams(Pooler, DWParams);
           If Assigned(TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler].OnAuthRequest) Then
            TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler].OnAuthRequest(DWParams, vRejected, vErrorMessage, ErrorCode, RequestHeader);
           If Not vRejected Then
            Begin
             Try
              If Assigned(TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler].OnBeforeExecute) Then
               TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler].OnBeforeExecute(TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler]);
              If Assigned(TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler].OnReplyEventByType) Then
               TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler].OnReplyEventByType(DWParams, vResult, RequestType, ErrorCode, RequestHeader)
              Else If Assigned(TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler].OnReplyEvent) Then
               TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler].OnReplyEvent(DWParams, vResult);
              JsonMode := TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler].JsonMode;
             Except
              On E : Exception Do
               Begin
                 //Alexandre Magno - 22/01/2019
                 If DWParams.ItemsString['dwencodestrings'] <> Nil Then
                  vResult := EncodeStrings(e.Message{$IFDEF FPC}, vDatabaseCharSet{$ENDIF})
                 Else
                  vResult := e.Message;
                Result  := True;
                If (ErrorCode <= 0)  Or
                   (ErrorCode = 200) Then
                 ErrorCode := 500;
//                Exit;
               End;
             End;
            End
           Else
            Begin
             If vErrorMessage <> '' Then
              Begin
               ContentType := 'text/html';
               vResult     := vErrorMessage;
              End
             Else
              vResult   := 'The Requested URL was Rejected';
             If (ErrorCode <= 0)  Or
                (ErrorCode = 200) Then
              ErrorCode := 401;
            End;
           If Trim(vResult) = '' Then
            vResult := TReplyOK;
          End
         Else
          Begin
           vStrAcceptedRoutes := '';
           vDWRoutes := TDWServerEvents(ServerMethodsClass.Components[i]).Events.EventByName[Pooler].Routes;
           If crGet in vDWRoutes Then
            Begin
             If vStrAcceptedRoutes <> '' Then
              vStrAcceptedRoutes := vStrAcceptedRoutes + ', GET'
             Else
              vStrAcceptedRoutes := 'GET';
            End;
           If crPost in vDWRoutes Then
            Begin
               If vStrAcceptedRoutes <> '' Then
                vStrAcceptedRoutes := vStrAcceptedRoutes + ', POST'
               Else
                vStrAcceptedRoutes := 'POST';
            End;
           If crPut in vDWRoutes Then
            Begin
             If vStrAcceptedRoutes <> '' Then
              vStrAcceptedRoutes := vStrAcceptedRoutes + ', PUT'
             Else
              vStrAcceptedRoutes := 'PUT';
            End;
           If crPatch in vDWRoutes Then
            Begin
             If vStrAcceptedRoutes <> '' Then
              vStrAcceptedRoutes := vStrAcceptedRoutes + ', PATCH'
             Else
              vStrAcceptedRoutes := 'PATCH';
            End;
           If crDelete in vDWRoutes Then
            Begin
             If vStrAcceptedRoutes <> '' Then
              vStrAcceptedRoutes := vStrAcceptedRoutes + ', DELETE'
             Else
              vStrAcceptedRoutes := 'DELETE';
            End;
           if vStrAcceptedRoutes <> '' then
            begin
              vResult   := 'Request rejected. Acceptable HTTP methods: '+vStrAcceptedRoutes;
              ErrorCode := 403;
            end
           else
            begin
              vResult   := 'Acceptable HTTP methods not defined on server';
              ErrorCode := 500;
            end;
          End;
         Break;
        End
       Else
        Begin
         vResult := 'Event not found...';
        End;
      End;
    End;
  End;
 If Not vTagService Then
  If (ErrorCode <= 0)  Or
     (ErrorCode = 200) Then
   ErrorCode := 404;
End;

Procedure TRESTServicePooler.GetEvents(ServerMethodsClass : TComponent;
                                       Var Pooler,
                                       urlContext         : String;
                                       Var DWParams       : TDWParams);
Var
 I         : Integer;
 vError    : Boolean;
 vTempJSON : String;
 iContSE   : Integer;
Begin
 vTempJSON := '';
 If ServerMethodsClass <> Nil Then
  Begin
   iContSE := 0;
   For I := 0 To ServerMethodsClass.ComponentCount -1 Do
    Begin
     If (ServerMethodsClass.Components[i] is TDWServerEvents) Then
      Begin
       iContSE := iContSE + 1;
       If (LowerCase(urlContext) = LowerCase(TDWServerEvents(ServerMethodsClass.Components[i]).ContextName)) or
          (LowerCase(urlContext) = LowerCase(ServerMethodsClass.Components[i].Name)) Or
          (LowerCase(urlContext) = LowerCase(Format('%s.%s', [ServerMethodsClass.Classname, ServerMethodsClass.Components[i].Name])))  Then
        Begin
         If vTempJSON = '' Then
          vTempJSON := Format('%s', [TDWServerEvents(ServerMethodsClass.Components[i]).Events.ToJSON])
         Else
          vTempJSON := vTempJSON + Format(', %s', [TDWServerEvents(ServerMethodsClass.Components[i]).Events.ToJSON]);
         Break;
        End;
      End;
    End;
   vError := vTempJSON = '';
   If vError Then
    Begin
     DWParams.ItemsString['MessageError'].AsString := 'Event Not Found';
     If iContSE > 1 then
      DWParams.ItemsString['MessageError'].AsString := 'There is more than one ServerEvent.'+ sLineBreak +
                                                       'Choose the desired ServerEvent in the ServerEventName property.';
    End;
   DWParams.ItemsString['Error'].AsBoolean        := vError;
   If DWParams.ItemsString['Result'] <> Nil Then
    Begin
     If vTempJSON <> '' Then
      DWParams.ItemsString['Result'].SetValue(Format('[%s]', [vTempJSON]), DWParams.ItemsString['Result'].Encoded)
     Else
      DWParams.ItemsString['Result'].SetValue('');
    End;
  End;
End;

Procedure TRESTServicePooler.OpenDatasets(ServerMethodsClass   : TComponent;
                                          Var Pooler           : String;
                                          Var DWParams         : TDWParams;
                                          ConnectionDefs       : TConnectionDefs;
                                          hEncodeStrings       : Boolean;
                                          AccessTag            : String;
                                          BinaryRequest        : Boolean);
Var
 I             : Integer;
 vTempJSON     : TJSONValue;
 vError        : Boolean;
 vMessageError : String;
 BinaryBlob    : TMemoryStream;
Begin
 BinaryBlob    := Nil;
 Try
  If ServerMethodsClass <> Nil Then
   Begin
    For I := 0 To ServerMethodsClass.ComponentCount -1 Do
     Begin
      If ServerMethodsClass.Components[i] is TRESTDWPoolerDB Then
       Begin
        If UpperCase(Pooler) = UpperCase(Format('%s.%s', [ServerMethodsClass.ClassName, ServerMethodsClass.Components[i].Name])) then
         Begin
          If Trim(TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag) <> '' Then
           Begin
            If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).AccessTag <> AccessTag Then
             Begin
              DWParams.ItemsString['MessageError'].AsString := 'Invalid Access tag...';
              DWParams.ItemsString['Error'].AsBoolean       := True;
              Exit;
             End;
           End;
          If TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver <> Nil Then
           Begin
            vError   := DWParams.ItemsString['Error'].AsBoolean;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.Encoding          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).Encoding;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.EncodeStringsJSON := hEncodeStrings;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim          := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsEmpty2Null    := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsEmpty2Null;
            TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.StrsTrim2Len      := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).StrsTrim2Len;
            Try
//             DWParams.ItemsString['LinesDataset'].CriptOptions.Use := False;
             TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.PrepareConnection(ConnectionDefs);
             vTempJSON := TRESTDWPoolerDB(ServerMethodsClass.Components[i]).RESTDriver.OpenDatasets(DWParams.ItemsString['LinesDataset'].Value,
                                                                                                    vError, vMessageError, BinaryBlob);
            Except
             On E : Exception Do
              Begin
               vMessageError := e.Message;
               vError := True;
              End;
            End;
            If vMessageError <> '' Then
             Begin
              DWParams.ItemsString['MessageError'].CriptOptions.Use := False;
              DWParams.ItemsString['MessageError'].AsString := EncodeStrings(vMessageError{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
             End;
            DWParams.ItemsString['Error'].AsBoolean        := vError;
            If DWParams.ItemsString['Result'] <> Nil Then
             Begin
              If BinaryRequest Then
               Begin
                If Not Assigned(BinaryBlob) Then
                 BinaryBlob  := TMemoryStream.Create;
                If Not vTempJSON.IsNull Then //vTempJSON <> Nil Then
                 Begin
                  vTempJSON.SaveToStream(BinaryBlob);
                  DWParams.ItemsString['Result'].LoadFromStream(BinaryBlob);
                  FreeAndNil(vTempJSON);
                 End
                Else
                 DWParams.ItemsString['Result'].SetValue('');
                FreeAndNil(BinaryBlob);
               End
              Else
               Begin
                If Not vTempJSON.IsNull Then //vTempJSON <> Nil Then
                 DWParams.ItemsString['Result'].SetValue(vTempJSON.ToJSON)
                Else
                 DWParams.ItemsString['Result'].SetValue('');
               End;
             End;
           End;
          Break;
         End;
       End;
     End;
   End;
 Finally
  If Assigned(vTempJSON) Then
   FreeAndNil(vTempJSON);
  If Assigned(BinaryBlob) Then
   FreeAndNil(BinaryBlob);
 End;
End;

Function TRESTServicePooler.ServiceMethods(BaseObject              : TComponent;
                                           AContext                : TIdContext;
                                           UrlMethod               : String;
                                           Var urlContext          : String;
                                           Var DWParams            : TDWParams;
                                           Var JSONStr             : String;
                                           Var JsonMode            : TJsonMode;
                                           Var ErrorCode           : Integer;
                                           Var ContentType         : String;
                                           Var ServerContextCall   : Boolean;
                                           Var ServerContextStream : TMemoryStream;
                                           ConnectionDefs          : TConnectionDefs;
                                           hEncodeStrings          : Boolean;
                                           AccessTag               : String;
                                           WelcomeAccept           : Boolean;
                                           Const RequestType       : TRequestType;
                                           mark                    : String;
                                           RequestHeader           : TStringList;
                                           BinaryEvent             : Boolean;
                                           Metadata                : Boolean;
                                           BinaryCompatibleMode    : Boolean) : Boolean;
Var
 vJsonMSG,
 vResult,
 vResultIP,
 vUrlMethod   :  String;
 vError,
 vInvalidTag  : Boolean;
 JSONParam    : TJSONParam;
Begin
 Result       := False;
 vUrlMethod   := UpperCase(UrlMethod);
 If WelcomeAccept Then
  Begin
   If vUrlMethod = UpperCase('GetPoolerList') Then
    Begin
     Result     := True;
     GetPoolerList(BaseObject, vResult, AccessTag);
     If DWParams.ItemsString['Result'] = Nil Then
      Begin
       JSONParam                 := TJSONParam.Create(DWParams.Encoding);
       JSONParam.ParamName       := 'Result';
       JSONParam.ObjectDirection := odOut;
       DWParams.Add(JSONParam);
      End;
     DWParams.ItemsString['Result'].SetValue(vResult,
                                             DWParams.ItemsString['Result'].Encoded);
     JSONStr    := TReplyOK;
    End
   Else If vUrlMethod = UpperCase('GetServerEventsList') Then
    Begin
     Result     := True;
     GetServerEventsList(BaseObject, vResult, AccessTag);
     If DWParams.ItemsString['Result'] = Nil Then
      Begin
       JSONParam                 := TJSONParam.Create(DWParams.Encoding);
       JSONParam.ParamName       := 'Result';
       JSONParam.ObjectDirection := odOut;
       DWParams.Add(JSONParam);
      End;
     DWParams.ItemsString['Result'].SetValue(vResult,
                                             DWParams.ItemsString['Result'].Encoded);
     JSONStr    := TReplyOK;
    End
   Else If vUrlMethod = UpperCase('EchoPooler') Then
    Begin
     vJsonMSG := TReplyNOK;
     If DWParams.ItemsString['Pooler'] <> Nil Then
      Begin
       vResult    := DWParams.ItemsString['Pooler'].Value;
       EchoPooler(BaseObject, AContext, vResult, vResultIP, AccessTag, vInvalidTag);
       If DWParams.ItemsString['Result'] <> Nil Then
        DWParams.ItemsString['Result'].SetValue(vResultIP,
                                                DWParams.ItemsString['Result'].Encoded);
      End;
     Result     := vResultIP <> '';
     If Result Then
      JSONStr    := TReplyOK
     Else
      Begin
       If vInvalidTag Then
        JSONStr    := TReplyTagError
       Else
        JSONStr    := TReplyInvalidPooler;
       ErrorCode   := 405;
      End;
    End
   Else If vUrlMethod = UpperCase('ExecuteCommandPureJSON') Then
    Begin
     vResult    := DWParams.ItemsString['Pooler'].Value;
     ExecuteCommandPureJSON(BaseObject, vResult, DWParams, ConnectionDefs, hEncodeStrings, AccessTag, BinaryEvent, Metadata, BinaryCompatibleMode);
     Result     := True;
     If Not(DWParams.ItemsString['Error'].AsBoolean) Then
      JSONStr    := TReplyOK
     Else
      JSONStr   := TReplyNOK;
    End
   Else If vUrlMethod = UpperCase('ExecuteCommandJSON') Then
    Begin
     vResult    := DWParams.ItemsString['Pooler'].Value;
     ExecuteCommandJSON(BaseObject, vResult, DWParams, ConnectionDefs, hEncodeStrings, AccessTag, BinaryEvent, Metadata, BinaryCompatibleMode);
     Result     := True;
     If Not(DWParams.ItemsString['Error'].AsBoolean) Then
      JSONStr    := TReplyOK
     Else
      JSONStr   := TReplyNOK;
    End
   Else If vUrlMethod = UpperCase('ApplyUpdates') Then
    Begin
     vResult    := DWParams.ItemsString['Pooler'].Value;
     ApplyUpdatesJSON(BaseObject, vResult, DWParams, ConnectionDefs, hEncodeStrings, AccessTag);
     Result     := True;
     If Not(DWParams.ItemsString['Error'].AsBoolean) Then
      JSONStr    := TReplyOK
     Else
      JSONStr   := TReplyNOK;
    End
   Else If vUrlMethod = UpperCase('ApplyUpdates_MassiveCache') Then
    Begin
     vResult    := DWParams.ItemsString['Pooler'].Value;
     ApplyUpdates_MassiveCache(BaseObject, vResult, DWParams, ConnectionDefs, hEncodeStrings, AccessTag);
     Result     := True;
     If Not(DWParams.ItemsString['Error'].AsBoolean) Then
      JSONStr    := TReplyOK
     Else
      JSONStr   := TReplyNOK;
    End
   Else If vUrlMethod = UpperCase('ProcessMassiveSQLCache') Then
    Begin
     vResult    := DWParams.ItemsString['Pooler'].Value;
     ProcessMassiveSQLCache(BaseObject, vResult, DWParams, ConnectionDefs, hEncodeStrings, AccessTag);
     Result     := True;
     If Not(DWParams.ItemsString['Error'].AsBoolean) Then
      JSONStr    := TReplyOK
     Else
      JSONStr   := TReplyNOK;
    End
   Else If vUrlMethod = UpperCase('GetTableNames') Then
    Begin
     vResult    := DWParams.ItemsString['Pooler'].Value;
     GetTableNames(BaseObject, vResult, DWParams, ConnectionDefs, hEncodeStrings, AccessTag);
     Result     := True;
     If Not(DWParams.ItemsString['Error'].AsBoolean) Then
      JSONStr    := TReplyOK
     Else
      JSONStr   := TReplyNOK;
    End
   Else If vUrlMethod = UpperCase('GetFieldNames') Then
    Begin
     vResult    := DWParams.ItemsString['Pooler'].Value;
     GetFieldNames(BaseObject, vResult, DWParams, ConnectionDefs, hEncodeStrings, AccessTag);
     Result     := True;
     If Not(DWParams.ItemsString['Error'].AsBoolean) Then
      JSONStr    := TReplyOK
     Else
      JSONStr   := TReplyNOK;
    End
   Else If vUrlMethod = UpperCase('GetKeyFieldNames') Then
    Begin
     vResult    := DWParams.ItemsString['Pooler'].Value;
     GetKeyFieldNames(BaseObject, vResult, DWParams, ConnectionDefs, hEncodeStrings, AccessTag);
     Result     := True;
     If Not(DWParams.ItemsString['Error'].AsBoolean) Then
      JSONStr    := TReplyOK
     Else
      JSONStr   := TReplyNOK;
    End
   Else If vUrlMethod = UpperCase('InsertMySQLReturnID_PARAMS') Then
    Begin
     vResult    := DWParams.ItemsString['Pooler'].Value;
     InsertMySQLReturnID(BaseObject, vResult, DWParams, ConnectionDefs, hEncodeStrings, AccessTag);
     Result     := True;
     If Not(DWParams.ItemsString['Error'].AsBoolean) Then
      JSONStr    := TReplyOK
     Else
      JSONStr   := TReplyNOK;
    End
   Else If vUrlMethod = UpperCase('InsertMySQLReturnID') Then
    Begin
     vResult    := DWParams.ItemsString['Pooler'].Value;
     InsertMySQLReturnID(BaseObject, vResult, DWParams, ConnectionDefs, hEncodeStrings, AccessTag);
     Result     := True;
     If Not(DWParams.ItemsString['Error'].AsBoolean) Then
      JSONStr    := TReplyOK
     Else
      JSONStr   := TReplyNOK;
    End
   Else If vUrlMethod = UpperCase('OpenDatasets') Then
    Begin
     vResult     := DWParams.ItemsString['Pooler'].Value;
     OpenDatasets(BaseObject, vResult, DWParams, ConnectionDefs, hEncodeStrings, AccessTag, BinaryEvent);
     Result      := True;
     If Not(DWParams.ItemsString['Error'].AsBoolean) Then
      JSONStr    := TReplyOK
     Else
      JSONStr   := TReplyNOK;
    End
   Else If vUrlMethod = UpperCase('GETEVENTS') Then
    Begin
     If DWParams.ItemsString['Error'] = Nil Then
      Begin
       JSONParam                 := TJSONParam.Create(DWParams.Encoding);
       JSONParam.ParamName       := 'Error';
       JSONParam.ObjectDirection := odOut;
       DWParams.Add(JSONParam);
      End;
     If DWParams.ItemsString['MessageError'] = Nil Then
      Begin
       JSONParam                 := TJSONParam.Create(DWParams.Encoding);
       JSONParam.ParamName       := 'MessageError';
       JSONParam.ObjectDirection := odOut;
       DWParams.Add(JSONParam);
      End;
     If DWParams.ItemsString['Result'] = Nil Then
      Begin
       JSONParam                 := TJSONParam.Create(DWParams.Encoding);
       JSONParam.ParamName       := 'Result';
       JSONParam.ObjectDirection := odOut;
       DWParams.Add(JSONParam);
      End;
     GetEvents(BaseObject, vResult, urlContext, DWParams);
     If Not(DWParams.ItemsString['Error'].AsBoolean) Then
      JSONStr    := TReplyOK
     Else
      Begin
       If DWParams.ItemsString['MessageError'] <> Nil Then
        JSONStr   := DWParams.ItemsString['MessageError'].AsString
       Else
        Begin
         JSONStr   := TReplyNOK;
         ErrorCode  := 500;
        End;
      End;
     Result      := JSONStr = TReplyOK;
    End
   Else
    Begin
     If ReturnEvent(BaseObject, vUrlMethod, vResult, urlContext, DWParams, JsonMode, ErrorCode, ContentType, Accesstag, RequestType, RequestHeader) Then
      Begin
       JSONStr := vResult;
       Result  := JSONStr <> '';
      End
     Else
      Begin
       ErrorCode := 200;
       Result  := ReturnContext(BaseObject, vUrlMethod, vResult, urlContext, ContentType, ServerContextStream, vError, DWParams, RequestType, Mark, RequestHeader, ErrorCode);
       If Not (Result) Or (vError) Then
        Begin
//         Result        := True;
         If Not WelcomeAccept Then
          Begin
           JsonMode    := jmPureJSON;
           JSONStr     := TReplyInvalidWelcome;
           If (ErrorCode <= 0) Or
              (ErrorCode = 200) Then
            ErrorCode  := 500;
          End
         Else
          Begin
           JsonMode   := jmPureJSON;
           JSONStr    := vResult;
           If (ErrorCode <= 0) Or
              (ErrorCode = 200) Then
            ErrorCode  := 404;
          End;
//         If vError Then
//          Result := True;
        End
       Else
        Begin
         ServerContextCall := True;
         JsonMode  := jmPureJSON;
         JSONStr   := vResult;
         {
         If (ErrorCode <= 0) Or
            (ErrorCode > 299) Then
          ErrorCode := 200;
          } // Manter o ErrorCode que o Server mandou
        End;
      End;
    End;
  End
 Else If (vUrlMethod = UpperCase('GETEVENTS')) And (Not (vForceWelcomeAccess)) Then
  Begin
   If DWParams.ItemsString['Error'] = Nil Then
    Begin
     JSONParam                 := TJSONParam.Create(DWParams.Encoding);
     JSONParam.ParamName       := 'Error';
     JSONParam.ObjectDirection := odOut;
     DWParams.Add(JSONParam);
    End;
   If DWParams.ItemsString['MessageError'] = Nil Then
    Begin
     JSONParam                 := TJSONParam.Create(DWParams.Encoding);
     JSONParam.ParamName       := 'MessageError';
     JSONParam.ObjectDirection := odOut;
     DWParams.Add(JSONParam);
    End;
   If DWParams.ItemsString['Result'] = Nil Then
    Begin
     JSONParam                 := TJSONParam.Create(DWParams.Encoding);
     JSONParam.ParamName       := 'Result';
     JSONParam.ObjectDirection := odOut;
     DWParams.Add(JSONParam);
    End;
   GetEvents(BaseObject, vResult, urlContext, DWParams);
   If Not(DWParams.ItemsString['Error'].AsBoolean) Then
    JSONStr    := TReplyOK
   Else
    Begin
     If DWParams.ItemsString['MessageError'] <> Nil Then
      JSONStr   := DWParams.ItemsString['MessageError'].AsString
     Else
      Begin
       JSONStr   := TReplyNOK;
       ErrorCode  := 500;
      End;
    End;
   Result      := JSONStr = TReplyOK;
  End
 Else If (Not (vForceWelcomeAccess)) Then
  Begin
   If Not WelcomeAccept Then
    JSONStr := TReplyInvalidWelcome
   Else
    Begin
     If ReturnEvent(BaseObject, vUrlMethod, vResult, urlContext, DWParams, JsonMode, ErrorCode, ContentType, Accesstag, RequestType, RequestHeader) Then
      Begin
       JSONStr := vResult;
       Result  := JSONStr <> '';
      End
     Else
      Begin
       ErrorCode := 200;
       Result  := ReturnContext(BaseObject, vUrlMethod, vResult, urlContext, ContentType, ServerContextStream, vError, DWParams, RequestType, Mark, RequestHeader, ErrorCode);
       If Not (Result) Or (vError) Then
        Begin
         If Not WelcomeAccept Then
          Begin
           JsonMode   := jmPureJSON;
           JSONStr    := TReplyInvalidWelcome;
           If (ErrorCode <= 0) Or
              (ErrorCode = 200) Then
            ErrorCode  := 500;
          End
         Else
          Begin
           JsonMode   := jmPureJSON;
           JSONStr := vResult;
           If (ErrorCode <= 0) Or
              (ErrorCode = 200) Then
            ErrorCode  := 404;
           Result  := False;
          End;
        End
       Else
        Begin
         JsonMode  := jmPureJSON;
         JSONStr   := vResult;
         If (ErrorCode <= 0)  Or
            (ErrorCode > 299) Then
          ErrorCode := 200;
        End;
      End;
    End;
  End
 Else
  Begin
   If Not WelcomeAccept Then
    JSONStr := TReplyInvalidWelcome
   Else
    JSONStr := TReplyNOK;
   Result  := False;
   If DWParams.ItemsString['Error']        <> Nil Then
    DWParams.ItemsString['Error'].AsBoolean := True;
   If DWParams.ItemsString['MessageError'] <> Nil Then
    DWParams.ItemsString['MessageError'].AsString := 'Invalid welcomemessage...'
   Else
    Begin
     If (ErrorCode <= 0)  Or
        (ErrorCode = 200) Then
      ErrorCode  := 500;
    End;
  End;
End;

Procedure TRESTServicePooler.aCommandGet(AContext      : TIdContext;
                                         ARequestInfo  : TIdHTTPRequestInfo;
                                         AResponseInfo : TIdHTTPResponseInfo);
Var
 I, vErrorCode      : Integer;
 JsonMode           : TJsonMode;
 DWParams           : TDWParams;
 vOldMethod,
 vBasePath,
 vObjectName,
 vAccessTag,
 vWelcomeMessage,
 boundary,
 startboundary,
 vReplyString,
 vReplyStringResult,
 urlContext,
 baseEventUnit,
 serverEventsName,
 Cmd, vmark,
 aurlContext,
 UrlMethod,
 tmp, JSONStr,
 ReturnObject,
 sFile,
 sContentType,
 vContentType,
 LocalDoc,
 vIPVersion,
 vErrorMessage,
 vToken,
 vDataBuff,
 sCharSet            : String;
 vdwConnectionDefs   : TConnectionDefs;
 vTempServerMethods  : TObject;
 newdecoder,
 Decoder             : TIdMessageDecoder;
 JSONParam           : TJSONParam;
 JSONValue           : TJSONValue;
 vMetadata,
 vBinaryCompatibleMode,
 vBinaryEvent,
 dwassyncexec,
 vFileExists,
 vSpecialServer,
 vServerContextCall,
 vTagReply,
 WelcomeAccept,
 encodestrings,
 compresseddata,
 vdwCriptKey,
 vGettoken,
 msgEnd              : Boolean;
 vServerBaseMethod   : TComponentClass;
 ServerContextStream,
 mb2                 : TMemoryStream;
 mb,
 ms                  : TStringStream;
 RequestType         : TRequestType;
 vRequestHeader,
 vDecoderHeaderList  : TStringList;
 {$IFNDEF FPC}
 {$IF CompilerVersion > 21}
 {$IFDEF WINDOWS}
  vCriticalSection : TRTLCriticalSection;
 {$ELSE}
  vCriticalSection : TCriticalSection;
 {$ENDIF}
 {$ELSE}
  vCriticalSection : TCriticalSection;
 {$IFEND}
 {$ENDIF}
 Function ExcludeTag(Value : String) : String;
 Begin
  Result := Value;
  If (UpperCase(Copy (Value, InitStrPos, 3)) = 'GET')    or
     (UpperCase(Copy (Value, InitStrPos, 4)) = 'POST')   or
     (UpperCase(Copy (Value, InitStrPos, 3)) = 'PUT')    or
     (UpperCase(Copy (Value, InitStrPos, 6)) = 'DELETE') or
     (UpperCase(Copy (Value, InitStrPos, 5)) = 'PATCH')  Then
   Begin
    While (Result <> '') And (Result[InitStrPos] <> '/') Do
     Delete(Result, 1, 1);
   End;
  If Result <> '' Then
   If Result[InitStrPos] = '/' Then
    Delete(Result, 1, 1);
  Result := Trim(Result);
 End;
 Function GetFileOSDir(Value : String) : String;
 Begin
  {$IF Defined(ANDROID) Or Defined(IOS)}
  Result := System.IOUtils.TPath.Combine(System.IOUtils.TPath.GetDocumentsPath, Value);
  {$ELSE}
  Result := vBasePath + Value;
  {$IFEND}
  {$IFDEF MSWINDOWS}
   Result := StringReplace(Result, '/', '\', [rfReplaceAll]);
  {$ENDIF}
 End;
 Function GetLastMethod(Value : String) : String;
 Var
  I : Integer;
 Begin
  Result := '';
  If Value <> '' Then
   Begin
    If Value[Length(Value) - FinalStrPos] <> '/' Then
     Begin
      For I := (Length(Value) - FinalStrPos) Downto InitStrPos Do
       Begin
        If Value[I] <> '/' Then
         Result := Value[I] + Result
        Else
         Break;
       End;
     End;
   End;
 End;
 procedure ReadRawHeaders;
 var
  I: Integer;
 begin
  If ARequestInfo.RawHeaders = Nil Then
   Exit;
  Try
   If ARequestInfo.RawHeaders.Count > 0 Then
    Begin
     vRequestHeader.Add(ARequestInfo.RawHeaders.Text);
     For I := 0 To ARequestInfo.RawHeaders.Count -1 Do
      Begin
       tmp := ARequestInfo.RawHeaders.Names[I];
       If pos('dwwelcomemessage', lowercase(tmp)) > 0 Then
        vWelcomeMessage := DecodeStrings(ARequestInfo.RawHeaders.Values[tmp]{$IFDEF FPC}, vDatabaseCharSet{$ENDIF})
       Else If pos('dwaccesstag', lowercase(tmp)) > 0 Then
        vAccessTag := DecodeStrings(ARequestInfo.RawHeaders.Values[tmp]{$IFDEF FPC}, vDatabaseCharSet{$ENDIF})
       Else If pos('datacompression', lowercase(tmp)) > 0 Then
        compresseddata := StringToBoolean(ARequestInfo.RawHeaders.Values[tmp])
       Else If pos('dwencodestrings', lowercase(tmp)) > 0 Then
        encodestrings  := StringToBoolean(ARequestInfo.RawHeaders.Values[tmp])
       Else If pos('dwusecript', lowercase(tmp)) > 0 Then
        vdwCriptKey    := StringToBoolean(ARequestInfo.RawHeaders.Values[tmp])
       Else If pos('dwassyncexec', lowercase(tmp)) > 0 Then
        dwassyncexec   := StringToBoolean(ARequestInfo.RawHeaders.Values[tmp])
       Else if pos('binaryrequest', lowercase(tmp)) > 0 Then
        vBinaryEvent   := StringToBoolean(ARequestInfo.RawHeaders.Values[tmp])
       Else If pos('dwconnectiondefs', lowercase(tmp)) > 0 Then
        Begin
         vdwConnectionDefs   := TConnectionDefs.Create;
         JSONValue           := TJSONValue.Create;
         Try
          JSONValue.Encoding  := VEncondig;
          JSONValue.Encoded  := True;
          JSONValue.LoadFromJSON(ARequestInfo.RawHeaders.Values[tmp]);
          vdwConnectionDefs.LoadFromJSON(JSONValue.Value);
         Finally
          FreeAndNil(JSONValue);
         End;
        End
       Else If pos('dwservereventname', lowercase(tmp)) > 0  Then
        Begin
         JSONValue           := TJSONValue.Create;
         Try
          JSONValue.Encoding  := VEncondig;
          JSONValue.Encoded  := True;
          {$IFDEF FPC}
          JSONValue.DatabaseCharSet := vDatabaseCharSet;
          {$ENDIF}
          JSONValue.LoadFromJSON(ARequestInfo.RawHeaders.Values[tmp]);
          urlContext := JSONValue.Value;
          If Pos('.', urlContext) > 0 Then
           Begin
            baseEventUnit := Copy(urlContext, InitStrPos, Pos('.', urlContext) - 1 - FinalStrPos);
            urlContext    := Copy(urlContext, Pos('.', urlContext) + 1, Length(urlContext));
           End;
         Finally
          FreeAndNil(JSONValue);
         End;
        End
       Else
        Begin
         If Not Assigned(DWParams) Then
          TServerUtils.ParseWebFormsParams (ARequestInfo.Params, {$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF},
                                            ARequestInfo.QueryParams,
                                            UrlMethod, urlContext, vmark, VEncondig{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}, DWParams);
         try
          JSONParam                 := TJSONParam.Create(DWParams.Encoding);
          JSONParam.ObjectDirection := odIN;
          JSONParam.ParamName       := lowercase(tmp);
          {$IFDEF FPC}
          JSONParam.DatabaseCharSet := vDatabaseCharSet;
          {$ENDIF}
          tmp                       := ARequestInfo.RawHeaders.Values[tmp];
          If (Pos(LowerCase('{"ObjectType":"toParam", "Direction":"'), LowerCase(tmp)) > 0) Then
           JSONParam.FromJSON(tmp)
          Else
           JSONParam.AsString  := tmp;
          DWParams.Add(JSONParam);
         finally
         end;
        End;
      End;
    End;
  Finally
   tmp := '';
  End;
 end;
 Procedure MyDecodeAndSetParams(ARequestInfo: TIdHTTPRequestInfo);
 Var
  i, j      : Integer;
  value, s  : String;
  {$IFNDEF FPC}
    {$IF (DEFINED(OLDINDY))}
     LEncoding : TIdTextEncoding
    {$ELSE}
     LEncoding : IIdTextEncoding
    {$IFEND}
  {$ELSE}
   LEncoding : IIdTextEncoding
  {$ENDIF};
 Begin
  If ARequestInfo.CharSet <> '' Then
   LEncoding := CharsetToEncoding(ARequestInfo.CharSet)
  Else
  {$IFNDEF FPC}
    {$IF (DEFINED(OLDINDY))}
     LEncoding := enDefault;
    {$ELSE}
     LEncoding := IndyTextEncoding_UTF8;
    {$IFEND}
  {$ELSE}
   LEncoding := IndyTextEncoding_UTF8;
  {$ENDIF};
  value := ARequestInfo.RawHeaders.Text;
  Try
   i := 1;
   While i <= Length(value) Do
    Begin
     j := i;
     While (j <= Length(value)) And (value[j] <> '&') Do
      Inc(j);
     s := StringReplace(Copy(value, i, j-i), '+', ' ', [rfReplaceAll]);
     ARequestInfo.Params.Add(TIdURI.URLDecode(s{$IFNDEF FPC}{$IF Not(DEFINED(OLDINDY))}, LEncoding{$IFEND}{$ELSE}, LEncoding{$ENDIF}));
     i := j + 1;
    End;
  Finally
  End;
 End;
Begin
 mb2                := Nil;
 mb                 := Nil;
 ms                 := Nil;
 tmp                := '';
 vIPVersion         := 'ipv4';
 JsonMode           := jmDataware;
 baseEventUnit      := '';
 vAccessTag         := '';
 vErrorMessage      := '';
 {$IFNDEF FPC}
 vCriticalSection   := Nil;
 {$ENDIF}
 {$IF Defined(ANDROID) Or Defined(IOS)}
 vBasePath          := System.IOUtils.TPath.Combine(System.IOUtils.TPath.GetDocumentsPath, '/');
 {$ELSE}
 vBasePath          := ExtractFilePath(ParamStr(0));
 {$IFEND}
 if Assigned(vServerMethod) then
  begin
   If (vServerMethod.ClassParent      = TServerMethods) Or
      (vServerMethod                  = TServerMethods) Then
    vServerBaseMethod := TServerMethods
   Else If (vServerMethod.ClassParent = TServerMethodDatamodule) Or
           (vServerMethod             = TServerMethodDatamodule) Then
    vServerBaseMethod := TServerMethodDatamodule;
  end;
 vContentType          := vContentType;
 vdwConnectionDefs     := Nil;
 vTempServerMethods    := Nil;
 DWParams              := Nil;
 ServerContextStream   := Nil;
 mb                    := Nil;
 compresseddata        := False;
 encodestrings         := False;
 vTagReply             := False;
 vServerContextCall    := False;
 dwassyncexec          := False;
 vBinaryEvent          := False;
 vBinaryCompatibleMode := False;
 vMetadata             := False;
 vdwCriptKey           := False;
 vGettoken             := False;
 vErrorCode            := 200;
 vToken                := '';
 vDataBuff             := '';
 vRequestHeader        := TStringList.Create;
 Cmd                   := Trim(ARequestInfo.RawHTTPCommand);
// MyDecodeAndSetParams(ARequestInfo);
 If vCORS Then
  Begin
   If vCORSCustomHeaders.Count > 0 Then
    Begin
     For I := 0 To vCORSCustomHeaders.Count -1 Do
      AResponseInfo.CustomHeaders.AddValue(vCORSCustomHeaders.Names[I], vCORSCustomHeaders.ValueFromIndex[I]);
    End
   Else
    AResponseInfo.CustomHeaders.AddValue('Access-Control-Allow-Origin','*');
  End;
  sCharSet := '';
 If (UpperCase(Copy (Cmd, 1, 3)) = 'GET')    Then
  Begin
   If     (Pos('.HTML', UpperCase(Cmd)) > 0) Then
    Begin
     sContentType:='text/html';
	   sCharSet := 'utf-8';
    End
   Else If (Pos('.PNG', UpperCase(Cmd)) > 0) Then
    sContentType := 'image/png'
   Else If (Pos('.ICO', UpperCase(Cmd)) > 0) Then
    sContentType := 'image/ico'
   Else If (Pos('.GIF', UpperCase(Cmd)) > 0) Then
    sContentType := 'image/gif'
   Else If (Pos('.JPG', UpperCase(Cmd)) > 0) Then
    sContentType := 'image/jpg'
   Else If (Pos('.JS',  UpperCase(Cmd)) > 0) Then
    sContentType := 'application/javascript'
   Else If (Pos('.PDF', UpperCase(Cmd)) > 0) Then
    sContentType := 'application/pdf'
   Else If (Pos('.CSS', UpperCase(Cmd)) > 0) Then
    sContentType:='text/css';
   {$IFNDEF FPC}
    {$if CompilerVersion > 21}
     sFile := FRootPath+ ARequestInfo.URI;
    {$ELSE}
     sFile := FRootPath+ ARequestInfo.Command;
    {$IFEND}
   {$ELSE}
    sFile := FRootPath+ARequestInfo.URI;
   {$ENDIF}
   If DWFileExists(sFile, FRootPath) then
    Begin
     AResponseInfo.ContentType := GetMIMEType(sFile);
     {$IFNDEF FPC}
      {$if CompilerVersion > 21}
     	 If (sCharSet <> '') Then
        AResponseInfo.CharSet := sCharSet;
      {$IFEND}
     {$ENDIF}
     AResponseInfo.ContentStream := TIdReadFileExclusiveStream.Create(sFile);
     AResponseInfo.WriteContent;
     Exit;
    End;
  End;
 Try
  Cmd := Trim(ARequestInfo.RawHTTPCommand);
  vRequestHeader.Add(Cmd);
  Cmd := StringReplace(Cmd, ' HTTP/1.0', '', [rfReplaceAll]);
  Cmd := StringReplace(Cmd, ' HTTP/1.1', '', [rfReplaceAll]);
  Cmd := StringReplace(Cmd, ' HTTP/2.0', '', [rfReplaceAll]);
  Cmd := StringReplace(Cmd, ' HTTP/2.1', '', [rfReplaceAll]);
  If ((vCORS) And (UpperCase(Copy (Cmd, 1, 7)) <> 'OPTIONS') And (vServerParams.HasAuthentication)) Or
     (vServerParams.HasAuthentication) Then
   Begin
    If Not ((ARequestInfo.AuthUsername = vServerParams.Username)  And
            (ARequestInfo.AuthPassword = vServerParams.Password)) Then
     Begin
      AResponseInfo.AuthRealm := AuthRealm;
      AResponseInfo.WriteContent;
      Exit;
     End;
   End;
  If (UpperCase(Copy (Cmd, 1, 3)) = 'GET' )   OR
     (UpperCase(Copy (Cmd, 1, 4)) = 'POST')   OR
     (UpperCase(Copy (Cmd, 1, 3)) = 'PUT')    OR
     (UpperCase(Copy (Cmd, 1, 4)) = 'DELE')   OR
     (UpperCase(Copy (Cmd, 1, 4)) = 'PATC')   Then
   Begin
    RequestType := rtGet;
    If (UpperCase(Copy (Cmd, 1, 4))      = 'POST') Then
     RequestType := rtPost
    Else If (UpperCase(Copy (Cmd, 1, 3)) = 'PUT')  Then
     RequestType := rtPut
    Else If (UpperCase(Copy (Cmd, 1, 4)) = 'DELE') Then
     RequestType := rtDelete
    Else If (UpperCase(Copy (Cmd, 1, 4)) = 'PATC') Then
     RequestType := rtPatch;
    {$IFNDEF FPC}
     If {$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF} = '/favicon.ico' Then
      Exit;
    {$ELSE}
     If ARequestInfo.URI = '/favicon.ico' Then
      Exit;
    {$ENDIF}
    // Tiago Istuque - 28/12/2018
    // Acredito ser correto chamar aqui a fun�ao ReadRawReader criada para ler dados do Header
    // Dessa forma obtemos cabe�alhos contendo mais informa��o sobre o conte�do da entidade,
    // como o tamanho do conte�do ou o seu MIME-type
    ReadRawHeaders;
    If ((ARequestInfo.Params.Count > 0) And (RequestType In [rtGet, rtDelete])) Then
     Begin
      {$IFNDEF FPC}
       vRequestHeader.Add({$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF});
      {$ELSE}
       vRequestHeader.Add(ARequestInfo.URI);
      {$ENDIF}
      vRequestHeader.Add(ARequestInfo.Params.Text);
      vRequestHeader.Add(ARequestInfo.QueryParams);
      TServerUtils.ParseWebFormsParams(DWParams, ARequestInfo.Params, {$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF},
                                       ARequestInfo.QueryParams,
                                       UrlMethod, urlContext, vmark, VEncondig{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}, RequestTypeToString(RequestType));
      If DWParams <> Nil Then
       Begin
        If (DWParams.ItemsString['dwwelcomemessage']     <> Nil)    Then
         vWelcomeMessage       := DecodeStrings(DWParams.ItemsString['dwwelcomemessage'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
        If (DWParams.ItemsString['dwaccesstag']          <> Nil)    Then
         vAccessTag            := DecodeStrings(DWParams.ItemsString['dwaccesstag'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
        If (DWParams.ItemsString['datacompression']      <> Nil)    Then
         compresseddata        := StringToBoolean(DWParams.ItemsString['datacompression'].AsString);
        If (DWParams.ItemsString['dwencodestrings']      <> Nil)    Then
         encodestrings         := StringToBoolean(DWParams.ItemsString['dwencodestrings'].AsString);
        If (DWParams.ItemsString['dwusecript']           <> Nil)    Then
         vdwCriptKey           := StringToBoolean(DWParams.ItemsString['dwusecript'].AsString);
        If (DWParams.ItemsString['BinaryCompatibleMode'] <> Nil)    Then
         vBinaryCompatibleMode := DWParams.ItemsString['BinaryCompatibleMode'].Value;
        If (DWParams.ItemsString['dwservereventname']    <> Nil)    Then
         Begin
          urlContext := '';
          If Not (DWParams.ItemsString['dwservereventname'].IsNull) Then
           urlContext := DecodeStrings(DWParams.ItemsString['dwservereventname'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
         End;
       End;
     End
    Else
     Begin
      If (RequestType In [rtGet, rtDelete]) Then
       Begin
        aurlContext := urlContext;
        If Not Assigned(DWParams) Then
         TServerUtils.ParseRESTURL ({$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF}, VEncondig, UrlMethod, urlContext, vmark{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}, DWParams);
        vOldMethod := UrlMethod;
        If DWParams <> Nil Then
         Begin
          If DWParams.ItemsString['dwwelcomemessage']      <> Nil  Then
           vWelcomeMessage       := DecodeStrings(DWParams.ItemsString['dwwelcomemessage'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
          If (DWParams.ItemsString['dwaccesstag']          <> Nil) Then
           vAccessTag            := DecodeStrings(DWParams.ItemsString['dwaccesstag'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
          If (DWParams.ItemsString['datacompression']      <> Nil) Then
           compresseddata        := StringToBoolean(DWParams.ItemsString['datacompression'].AsString);
          If (DWParams.ItemsString['dwencodestrings']      <> Nil) Then
           encodestrings         := StringToBoolean(DWParams.ItemsString['dwencodestrings'].AsString);
          If (DWParams.ItemsString['dwservereventname']    <> Nil) Then
           urlContext            := DWParams.ItemsString['dwservereventname'].AsString;
          If (DWParams.ItemsString['dwusecript']           <> Nil) Then
           vdwCriptKey           := StringToBoolean(DWParams.ItemsString['dwusecript'].AsString);
          If (DWParams.ItemsString['dwassyncexec']         <> Nil) Then
           dwassyncexec          := StringToBoolean(DWParams.ItemsString['dwassyncexec'].AsString);
          If (DWParams.ItemsString['BinaryCompatibleMode'] <> Nil) Then
           vBinaryCompatibleMode := DWParams.ItemsString['BinaryCompatibleMode'].Value;
         End;
        If (urlContext = '') And (aurlContext <> '') Then
         urlContext := aurlContext;
       End;
      If (RequestType In [rtPut, rtPatch, rtDelete]) Then //New Code to Put
       Begin
        If ARequestInfo.FormParams <> '' Then
         Begin
          TServerUtils.ParseFormParamsToDWParam(ARequestInfo.FormParams, VEncondig, DWParams{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
          If (DWParams.ItemsString['dwwelcomemessage']     <> Nil) Then
           vWelcomeMessage       := DecodeStrings(DWParams.ItemsString['dwwelcomemessage'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
          If (DWParams.ItemsString['dwaccesstag']          <> Nil) Then
           vAccessTag            := DecodeStrings(DWParams.ItemsString['dwaccesstag'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
          If (DWParams.ItemsString['datacompression']      <> Nil) Then
           compresseddata        := StringToBoolean(DWParams.ItemsString['datacompression'].AsString);
          If (DWParams.ItemsString['dwencodestrings']      <> Nil) Then
           encodestrings         := StringToBoolean(DWParams.ItemsString['dwencodestrings'].AsString);
          If (DWParams.ItemsString['dwservereventname']    <> Nil) Then
           urlContext            := DWParams.ItemsString['dwservereventname'].AsString;
          If (DWParams.ItemsString['dwusecript']           <> Nil) Then
           vdwCriptKey           := StringToBoolean(DWParams.ItemsString['dwusecript'].AsString);
          If (DWParams.ItemsString['dwassyncexec']         <> Nil) Then
           dwassyncexec          := StringToBoolean(DWParams.ItemsString['dwassyncexec'].AsString);
          If (DWParams.ItemsString['BinaryCompatibleMode'] <> Nil) Then
           vBinaryCompatibleMode := DWParams.ItemsString['BinaryCompatibleMode'].Value;
         End;
       End;
      If Assigned(ARequestInfo.PostStream) Then
       Begin
         ARequestInfo.PostStream.Position := 0;
         If Not vBinaryEvent Then
          Begin
           Try
            mb := TStringStream.Create(''); //{$IFNDEF FPC}{$if CompilerVersion > 21}, TEncoding.UTF8{$IFEND}{$ENDIF});
            try
             mb.CopyFrom(ARequestInfo.PostStream, ARequestInfo.PostStream.Size);
             ARequestInfo.PostStream.Position := 0;
             mb.Position := 0;
             If (pos('--', mb.DataString) > 0) and (pos('boundary', ARequestInfo.ContentType) > 0) Then
              Begin
                msgEnd   := False;
                {$IFNDEF FPC}
                 {$IF (DEFINED(OLDINDY))}
                  boundary := ExtractHeaderSubItem(ARequestInfo.ContentType, 'boundary');
                 {$ELSE}
                  boundary := ExtractHeaderSubItem(ARequestInfo.ContentType, 'boundary', QuoteHTTP);
                 {$IFEND}
                {$ELSE}
                 boundary := ExtractHeaderSubItem(ARequestInfo.ContentType, 'boundary', QuoteHTTP);
                {$ENDIF}
                startboundary := '--' + boundary;
                Repeat
                 tmp := ReadLnFromStream(ARequestInfo.PostStream, -1, True);
                until tmp = startboundary;
              End;
            finally
             if Assigned(mb) then
              FreeAndNil(mb);
            end;
           Except
           End;
          End;
        If (ARequestInfo.PostStream.Size > 0) And (boundary <> '') Then
         Begin
          Try
           Repeat
            decoder := TIdMessageDecoderMIME.Create(nil);
            TIdMessageDecoderMIME(decoder).MIMEBoundary := boundary;
            decoder.SourceStream := ARequestInfo.PostStream;
            decoder.FreeSourceStream := False;
            decoder.ReadHeader;
            Inc(I);
            Case Decoder.PartType of
             mcptAttachment:
              Begin
               ms := TStringStream.Create('');
               ms.Position := 0;
               NewDecoder := Decoder.ReadBody(ms, MsgEnd);
               vDecoderHeaderList := TStringList.Create;
               vDecoderHeaderList.Assign(Decoder.Headers);
               sFile := ExtractFileName(Decoder.FileName);
               FreeAndNil(Decoder);
               Decoder := NewDecoder;
               If Decoder <> Nil Then
                TIdMessageDecoderMIME(Decoder).MIMEBoundary := Boundary;
               If Not Assigned(DWParams) Then
                Begin
                 If (ARequestInfo.Params.Count = 0) Then
                  Begin
                   DWParams           := TDWParams.Create;
                   DWParams.Encoding  := VEncondig;
                  End
                 Else
                  TServerUtils.ParseWebFormsParams (ARequestInfo.Params, {$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF},
                                                    ARequestInfo.QueryParams,
                                                    UrlMethod, urlContext, vmark, VEncondig{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}, DWParams);
                End;
               JSONParam    := TJSONParam.Create(DWParams.Encoding);
               JSONParam.ObjectDirection := odIN;
               vObjectName  := '';
               sContentType := '';
               For I := 0 To vDecoderHeaderList.Count - 1 Do
                Begin
                 tmp := vDecoderHeaderList.Strings[I];
                 If Pos('; name="', lowercase(tmp)) > 0 Then
                  Begin
                   vObjectName := Copy(lowercase(tmp),
                                       Pos('; name="', lowercase(tmp)) + length('; name="'),
                                       length(lowercase(tmp)));
                   vObjectName := Copy(vObjectName, InitStrPos, Pos('"', vObjectName) -1);
                  End;
                 If Pos('content-type=', lowercase(tmp)) > 0 Then
                  Begin
                   sContentType := Copy(lowercase(tmp),
                                       Pos('content-type=', lowercase(tmp)) + length('content-type='),
                                       length(lowercase(tmp)));
                  End;
                End;
                // Corre��o de FORM-DATA / FILE criar parametros automaticos: ICO 20-09-2019
               If (vObjectName <> '') Then
                JSONParam.ParamName        := vObjectName
               Else
                Begin
                 vObjectName := 'dwfilename';
                 JSONParam.ParamName       := vObjectName
                End;
               If (sContentType =  '') And
                  (sFile        <> '') Then
                vObjectName := GetMIMEType(sFile);
               JSONParam.ParamName        := vObjectName;
               JSONParam.ParamFileName    := sFile;
               JSONParam.ParamContentType := sContentType;
               ms.Position := 0;
               JSONParam.LoadFromStream(ms);
               DWParams.Add(JSONParam);
               //Fim da corre��o - ICO
               ms.Free;
               vDecoderHeaderList.Free;
              End;
             mcptText :
              Begin
               {$IFDEF FPC}
               ms := TStringStream.Create('');
               {$ELSE}
               ms := TStringStream.Create(''{$if CompilerVersion > 21}, TEncoding.UTF8{$IFEND});
               {$ENDIF}
               ms.Position := 0;
               newdecoder  := Decoder.ReadBody(ms, msgEnd);
               tmp         := Decoder.Headers.Text;
               FreeAndNil(Decoder);
               Decoder     := newdecoder;
               vObjectName := '';
               If Decoder <> Nil Then
                TIdMessageDecoderMIME(Decoder).MIMEBoundary := Boundary;
               If pos('dwwelcomemessage', lowercase(tmp)) > 0      Then
                vWelcomeMessage := DecodeStrings(ms.DataString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF})
               Else If pos('dwaccesstag', lowercase(tmp)) > 0      Then
                vAccessTag := DecodeStrings(ms.DataString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF})
               Else If Pos('dwusecript', lowercase(tmp)) > 0       Then
                vdwCriptKey  := StringToBoolean(ms.DataString)
               Else If pos('datacompression', lowercase(tmp)) > 0  Then
                compresseddata := StringToBoolean(ms.DataString)
               Else If pos('dwencodestrings', lowercase(tmp)) > 0  Then
                encodestrings  := StringToBoolean(ms.DataString)
               Else If Pos('dwassyncexec', lowercase(tmp)) > 0     Then
                dwassyncexec := StringToBoolean(ms.DataString)
               Else If Pos('binaryrequest', lowercase(tmp)) > 0    Then
                vBinaryEvent := StringToBoolean(ms.DataString)
               Else If pos('dwconnectiondefs', lowercase(tmp)) > 0 Then
                Begin
                 vdwConnectionDefs   := TConnectionDefs.Create;
                 JSONValue           := TJSONValue.Create;
                 Try
                  JSONValue.Encoding  := VEncondig;
                  JSONValue.Encoded  := True;
                  JSONValue.LoadFromJSON(ms.DataString);
                  vdwConnectionDefs.LoadFromJSON(JSONValue.Value);
                 Finally
                  FreeAndNil(JSONValue);
                 End;
                End
               Else If pos('dwservereventname', lowercase(tmp)) > 0  Then
                Begin
                 JSONValue           := TJSONValue.Create;
                 Try
                  JSONValue.Encoding := VEncondig;
                  JSONValue.Encoded  := True;
                  JSONValue.LoadFromJSON(ms.DataString);
                  urlContext := JSONValue.Value;
                  If Pos('.', urlContext) > 0 Then
                   Begin
                    baseEventUnit := Copy(urlContext, InitStrPos, Pos('.', urlContext) - 1 - FinalStrPos);
                    urlContext    := Copy(urlContext, Pos('.', urlContext) + 1, Length(urlContext));
                   End;
                 Finally
                  FreeAndNil(JSONValue);
                 End;
                End
               Else
                Begin
                 If DWParams = Nil Then
                  Begin
                   DWParams           := TDWParams.Create;
                   DWParams.Encoding  := VEncondig;
                  End;
                 If (lowercase(vObjectName) = 'binarydata') then
                  Begin
                   DWParams.LoadFromStream(ms);
                   If Assigned(JSONParam) Then
                    FreeAndNil(JSONParam);
                   {$IFNDEF FPC}ms.Size := 0;{$ENDIF}
                   FreeAndNil(ms);
                   If DWParams <> Nil Then
                    Begin
                     If (DWParams.ItemsString['dwwelcomemessage']     <> Nil) Then
                      vWelcomeMessage       := DecodeStrings(DWParams.ItemsString['dwwelcomemessage'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
                     If (DWParams.ItemsString['dwaccesstag']          <> Nil) Then
                      vAccessTag            := DecodeStrings(DWParams.ItemsString['dwaccesstag'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
                     If (DWParams.ItemsString['datacompression']      <> Nil) Then
                      compresseddata        := StringToBoolean(DWParams.ItemsString['datacompression'].AsString);
                     If (DWParams.ItemsString['dwencodestrings']      <> Nil) Then
                      encodestrings         := StringToBoolean(DWParams.ItemsString['dwencodestrings'].AsString);
                     If (DWParams.ItemsString['dwservereventname']    <> Nil) Then
                      urlContext            := DWParams.ItemsString['dwservereventname'].AsString;
                     If (DWParams.ItemsString['dwusecript']           <> Nil) Then
                      vdwCriptKey           := StringToBoolean(DWParams.ItemsString['dwusecript'].AsString);
                     If (DWParams.ItemsString['dwassyncexec']         <> Nil) Then
                      dwassyncexec          := StringToBoolean(DWParams.ItemsString['dwassyncexec'].AsString);
                     If (DWParams.ItemsString['binaryrequest']        <> Nil) Then
                      vBinaryEvent          := StringToBoolean(DWParams.ItemsString['binaryrequest'].AsString);
                     If (DWParams.ItemsString['BinaryCompatibleMode'] <> Nil) Then
                      vBinaryCompatibleMode := DWParams.ItemsString['BinaryCompatibleMode'].Value;
                    End;
                   If Assigned(decoder) Then
                    FreeAndNil(decoder);
                   Continue;
                  End;
                 vObjectName := Copy(lowercase(tmp), Pos('; name="', lowercase(tmp)) + length('; name="'),  length(lowercase(tmp)));
                 vObjectName := Copy(vObjectName, InitStrPos, Pos('"', vObjectName) -1);
                 JSONParam   := TJSONParam.Create(DWParams.Encoding);
                 JSONParam.ObjectDirection := odIN;
                 If (Pos(Lowercase('{"ObjectType":"toParam", "Direction":"'), lowercase(ms.DataString)) > 0) Then
                  JSONParam.FromJSON(ms.DataString)
                 Else
                  JSONParam.AsString := StringReplace(StringReplace(ms.DataString, sLineBreak, '', [rfReplaceAll]), #13, '', [rfReplaceAll]);
                 JSONParam.ParamName := vObjectName;
                 DWParams.Add(JSONParam);
                End;
               {$IFNDEF FPC}ms.Size := 0;{$ENDIF}
               FreeAndNil(ms);
               If Assigned(Newdecoder)  Then
                FreeAndNil(Newdecoder);
              End;
             mcptIgnore :
              Begin
               Try
                If decoder <> Nil Then
                 FreeAndNil(decoder);
                decoder := TIdMessageDecoderMIME.Create(Nil);
                TIdMessageDecoderMIME(decoder).MIMEBoundary := boundary;
               Finally
               End;
              End;
            {$IFNDEF FPC}
             {$IF Not(DEFINED(OLDINDY))}
             mcptEOF:
              Begin
               FreeAndNil(decoder);
               msgEnd := True
              End;
             {$IFEND}
            {$ELSE}
             mcptEOF:
              Begin
               FreeAndNil(decoder);
               msgEnd := True
              End;
            {$ENDIF}
            End;
           Until (Decoder = Nil) Or (msgEnd);
          Finally
           If Assigned(decoder) then
            FreeAndNil(decoder);
          End;
         End
        Else
         Begin
          If (ARequestInfo.PostStream.Size > 0) And (boundary = '') Then
           Begin
            mb       := TStringStream.Create('');
            Try
             ARequestInfo.PostStream.Position := 0;
             mb.CopyFrom(ARequestInfo.PostStream, ARequestInfo.PostStream.Size);
             ARequestInfo.PostStream.Position := 0;
             mb.Position := 0;
             If Not Assigned(DWParams) Then
              TServerUtils.ParseWebFormsParams (ARequestInfo.Params, {$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF},
                                                ARequestInfo.QueryParams,
                                                UrlMethod, urlContext, vmark, VEncondig{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}, DWParams);
             {Altera��o feita por Tiago IStuque - 28/12/2018}
             If Assigned(DWParams.ItemsString['dwReadBodyRaw']) And (DWParams.ItemsString['dwReadBodyRaw'].AsString='1') Then
              TServerUtils.ParseBodyRawToDWParam(mb.DataString, VEncondig, DWParams{$IFDEF FPC}, vDatabaseCharSet{$ENDIF})
             Else If (Assigned(DWParams.ItemsString['dwReadBodyBin']) And
                     (DWParams.ItemsString['dwReadBodyBin'].AsString='1')) Then
              TServerUtils.ParseBodyBinToDWParam(mb.DataString, VEncondig, DWParams{$IFDEF FPC}, vDatabaseCharSet{$ENDIF})
             Else If (vBinaryEvent) Then
              Begin
               If (pos('--', mb.DataString) > 0) and (pos('boundary', ARequestInfo.ContentType) > 0) Then
                Begin
                 msgEnd   := False;
                 {$IFNDEF FPC}
                  {$IF (DEFINED(OLDINDY))}
                   boundary := ExtractHeaderSubItem(ARequestInfo.ContentType, 'boundary');
                  {$ELSE}
                   boundary := ExtractHeaderSubItem(ARequestInfo.ContentType, 'boundary', QuoteHTTP);
                  {$IFEND}
                 {$ELSE}
                  boundary := ExtractHeaderSubItem(ARequestInfo.ContentType, 'boundary', QuoteHTTP);
                 {$ENDIF}
                 startboundary := '--' + boundary;
                 Repeat
                  tmp := ReadLnFromStream(ARequestInfo.PostStream, -1, True);
                 Until tmp = startboundary;
                End;
                Try
                 Repeat
                  decoder := TIdMessageDecoderMIME.Create(nil);
                  TIdMessageDecoderMIME(decoder).MIMEBoundary := boundary;
                  decoder.SourceStream := ARequestInfo.PostStream;
                  decoder.FreeSourceStream := False;
                  decoder.ReadHeader;
                  Inc(I);
                  Case Decoder.PartType of
                   mcptAttachment:
                    Begin
                     ms := TStringStream.Create('');
                     ms.Position := 0;
                     NewDecoder := Decoder.ReadBody(ms, MsgEnd);
                     vDecoderHeaderList := TStringList.Create;
                     vDecoderHeaderList.Assign(Decoder.Headers);
                     sFile := ExtractFileName(Decoder.FileName);
                     FreeAndNil(Decoder);
                     Decoder := NewDecoder;
                     If Decoder <> Nil Then
                      TIdMessageDecoderMIME(Decoder).MIMEBoundary := Boundary;
                     If Not Assigned(DWParams) Then
                      Begin
                       If (ARequestInfo.Params.Count = 0) Then
                        Begin
                         DWParams           := TDWParams.Create;
                         DWParams.Encoding  := VEncondig;
                        End
                       Else
                        TServerUtils.ParseWebFormsParams (ARequestInfo.Params, {$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF},
                                                          ARequestInfo.QueryParams,
                                                          UrlMethod, urlContext, vmark, VEncondig{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}, DWParams);
                      End;
                     JSONParam    := TJSONParam.Create(DWParams.Encoding);
                     JSONParam.ObjectDirection := odIN;
                     vObjectName  := '';
                     sContentType := '';
                     for I := 0 to vDecoderHeaderList.Count - 1 do
                      begin
                       tmp := vDecoderHeaderList.Strings[I];
                       if Pos('; name="', lowercase(tmp)) > 0 then
                        begin
                         vObjectName := Copy(lowercase(tmp),
                                             Pos('; name="', lowercase(tmp)) + length('; name="'),
                                             length(lowercase(tmp)));
                         vObjectName := Copy(vObjectName, InitStrPos, Pos('"', vObjectName) -1);
                        end;
                       if Pos('content-type=', lowercase(tmp)) > 0 then
                        begin
                         sContentType := Copy(lowercase(tmp),
                                             Pos('content-type=', lowercase(tmp)) + length('content-type='),
                                             length(lowercase(tmp)));
                        end;
                      end;
                      // Corre��o de FORM-DATA / FILE criar parametros automaticos: ICO 20-09-2019
                      If (lowercase(vObjectName) = 'binarydata') then
                       Begin
                        DWParams.LoadFromStream(ms);
                        If Assigned(JSONParam) Then
                         FreeAndNil(JSONParam);
                        If (DWParams.ItemsString['dwwelcomemessage']     <> Nil) Then
                         vWelcomeMessage       := DecodeStrings(DWParams.ItemsString['dwwelcomemessage'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
                        If (DWParams.ItemsString['dwaccesstag']          <> Nil) Then
                         vAccessTag            := DecodeStrings(DWParams.ItemsString['dwaccesstag'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
                        If (DWParams.ItemsString['datacompression']      <> Nil) Then
                         compresseddata        := StringToBoolean(DWParams.ItemsString['datacompression'].AsString);
                        If (DWParams.ItemsString['dwencodestrings']      <> Nil) Then
                         encodestrings         := StringToBoolean(DWParams.ItemsString['dwencodestrings'].AsString);
                        If (DWParams.ItemsString['dwservereventname']    <> Nil) Then
                         urlContext            := DWParams.ItemsString['dwservereventname'].AsString;
                        If (DWParams.ItemsString['dwusecript']           <> Nil) Then
                         vdwCriptKey           := StringToBoolean(DWParams.ItemsString['dwusecript'].AsString);
                        If (DWParams.ItemsString['dwassyncexec']         <> Nil) Then
                         dwassyncexec          := StringToBoolean(DWParams.ItemsString['dwassyncexec'].AsString);
                        If (DWParams.ItemsString['binaryrequest']        <> Nil) Then
                         vBinaryEvent          := StringToBoolean(DWParams.ItemsString['binaryrequest'].AsString);
                        If (DWParams.ItemsString['BinaryCompatibleMode'] <> Nil) Then
                         vBinaryCompatibleMode := DWParams.ItemsString['BinaryCompatibleMode'].Value;
                        if DWParams.ItemsString['dwConnectionDefs'] <> Nil then
                        begin
                         if not Assigned(vdwConnectionDefs) then
                          vdwConnectionDefs := TConnectionDefs.Create;
                         JSONValue           := TJSONValue.Create;
                         Try
                          JSONValue.Encoding := VEncondig;
                          JSONValue.Encoded  := True;
                          JSONValue.LoadFromJSON(DWParams.ItemsString['dwConnectionDefs'].ToJSON);
                          vdwConnectionDefs.LoadFromJSON(JSONValue.Value);
                         Finally
                          FreeAndNil(JSONValue);
                         End;
                        end;
                        If Assigned(vDecoderHeaderList) Then
                         FreeAndNil(vDecoderHeaderList);
                        If Assigned(ms) Then
                         FreeAndNil(ms);
                        FreeAndNil(Decoder);
                        Continue;
                       End
                      Else If (vObjectName <> '') Then
                       Begin
                        JSONParam.ParamName        := vObjectName;
                        tmp := ms.DataString;
                        If Copy(tmp, Length(tmp) -1, 2) = sLineBreak Then
                         Delete(tmp, Length(tmp) -1, 2);
                        If VEncondig = esUtf8 Then
                         JSONParam.SetValue(utf8decode(tmp), JSONParam.Encoded)
                        Else
                         JSONParam.SetValue(tmp, JSONParam.Encoded);
                       End
                      Else
                       Begin
                        vObjectName := 'dwfilename';
                        if (sContentType = '') and (sFile <> '') then
                          vObjectName := GetMIMEType(sFile);
                        JSONParam.ParamName        := vObjectName;
                        JSONParam.ParamFileName    := sFile;
                        JSONParam.ParamContentType := sContentType;
                        If VEncondig = esUtf8 Then
                         JSONParam.SetValue(utf8decode(ms.DataString), JSONParam.Encoded)
                        Else
                         JSONParam.SetValue(ms.DataString, JSONParam.Encoded);
                       End;
                      DWParams.Add(JSONParam);
                     FreeAndNil(ms);
                     FreeAndNil(vDecoderHeaderList);
                    End;
                   mcptText :
                    begin
                     {$IFDEF FPC}
                     ms := TStringStream.Create('');
                     {$ELSE}
                     ms := TStringStream.Create(''{$if CompilerVersion > 21}, TEncoding.UTF8{$IFEND});
                     {$ENDIF}
                     ms.Position := 0;
                     newdecoder  := Decoder.ReadBody(ms, msgEnd);
                     tmp         := Decoder.Headers.Text;
                     FreeAndNil(Decoder);
                     Decoder     := newdecoder;
                     vObjectName := '';
                     If Decoder <> Nil Then
                      TIdMessageDecoderMIME(Decoder).MIMEBoundary := Boundary;
                     If pos('dwwelcomemessage', lowercase(tmp)) > 0      Then
                      vWelcomeMessage := DecodeStrings(ms.DataString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF})
                     Else If pos('dwaccesstag', lowercase(tmp)) > 0      Then
                      vAccessTag := DecodeStrings(ms.DataString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF})
                     Else If Pos('dwusecript', lowercase(tmp)) > 0       Then
                      vdwCriptKey  := StringToBoolean(ms.DataString)
                     Else If pos('datacompression', lowercase(tmp)) > 0  Then
                      compresseddata := StringToBoolean(ms.DataString)
                     Else If pos('dwencodestrings', lowercase(tmp)) > 0  Then
                      encodestrings  := StringToBoolean(ms.DataString)
                     Else If Pos('binaryrequest', lowercase(tmp)) > 0    Then
                      vBinaryEvent := StringToBoolean(ms.DataString)
                     Else If Pos('dwassyncexec', lowercase(tmp)) > 0     Then
                      dwassyncexec := StringToBoolean(ms.DataString)
                     Else If pos('dwconnectiondefs', lowercase(tmp)) > 0 Then
                      Begin
                       vdwConnectionDefs   := TConnectionDefs.Create;
                       JSONValue           := TJSONValue.Create;
                       Try
                        JSONValue.Encoding  := VEncondig;
                        JSONValue.Encoded  := True;
                        JSONValue.LoadFromJSON(ms.DataString);
                        vdwConnectionDefs.LoadFromJSON(JSONValue.Value);
                       Finally
                        FreeAndNil(JSONValue);
                       End;
                      End
                     Else If Pos('dwassyncexec', lowercase(tmp)) > 0       Then
                      dwassyncexec := StringToBoolean(ms.DataString)
                     Else If pos('dwservereventname', lowercase(tmp)) > 0  Then
                      Begin
                       JSONValue           := TJSONValue.Create;
                       Try
                        JSONValue.Encoding := VEncondig;
                        JSONValue.Encoded  := True;
                        JSONValue.LoadFromJSON(ms.DataString);
                        urlContext := JSONValue.Value;
                        If Pos('.', urlContext) > 0 Then
                         Begin
                          baseEventUnit := Copy(urlContext, InitStrPos, Pos('.', urlContext) - 1 - FinalStrPos);
                          urlContext    := Copy(urlContext, Pos('.', urlContext) + 1, Length(urlContext));
                         End;
                       Finally
                        FreeAndNil(JSONValue);
                       End;
                      End
                     Else
                      Begin
                       If DWParams = Nil Then
                        Begin
                         DWParams           := TDWParams.Create;
                         DWParams.Encoding  := VEncondig;
                        End;
                       vObjectName := Copy(lowercase(tmp), Pos('; name="', lowercase(tmp)) + length('; name="'),  length(lowercase(tmp)));
                       vObjectName := Copy(vObjectName, InitStrPos, Pos('"', vObjectName) -1);
                       JSONParam   := TJSONParam.Create(DWParams.Encoding);
                       JSONParam.ObjectDirection := odIN;
                       If (Pos(Lowercase('{"ObjectType":"toParam", "Direction":"'), lowercase(ms.DataString)) > 0) Then
                        JSONParam.FromJSON(ms.DataString)
                       Else
                        JSONParam.AsString := StringReplace(StringReplace(ms.DataString, sLineBreak, '', [rfReplaceAll]), #13, '', [rfReplaceAll]);
                       JSONParam.ParamName := vObjectName;
                       DWParams.Add(JSONParam);
                      End;
                     {$IFNDEF FPC}ms.Size := 0;{$ENDIF}
                     FreeAndNil(ms);
                     FreeAndNil(newdecoder);
                    end;
                   mcptIgnore :
                    Begin
                     Try
                      If decoder <> Nil Then
                       FreeAndNil(decoder);
                     Finally
                     End;
                    End;
                   {$IFNDEF FPC}
                    {$IF Not(DEFINED(OLDINDY))}
                    mcptEOF:
                     Begin
                      FreeAndNil(decoder);
                      msgEnd := True
                     End;
                    {$IFEND}
                   {$ELSE}
                   mcptEOF:
                    Begin
                     FreeAndNil(decoder);
                     msgEnd := True
                    End;
                   {$ENDIF}
                  End;
                 Until (Decoder = Nil) Or (msgEnd);
                Finally
                 If decoder <> nil then
                  FreeAndNil(decoder);
                End;
              End
             Else If (ARequestInfo.Params.Count = 0)
                      {$IFNDEF FPC}
                       {$If Not(DEFINED(OLDINDY))}
                        {$If (CompilerVersion > 23)}
                         And (ARequestInfo.QueryParams.Length = 0)
                        {$IFEND}
                       {$ELSE}
                        And (Length(ARequestInfo.QueryParams) = 0)
                       {$IFEND}
                      {$ELSE}
                       And (ARequestInfo.QueryParams.Length = 0)
                      {$ENDIF}Then
              Begin
               If VEncondig = esUtf8 Then
                TServerUtils.ParseBodyRawToDWParam(utf8decode(mb.DataString), VEncondig, DWParams{$IFDEF FPC}, vDatabaseCharSet{$ENDIF})
               Else
                TServerUtils.ParseBodyRawToDWParam(mb.DataString, VEncondig, DWParams{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
              End
             Else
              Begin
               If VEncondig = esUtf8 Then
                TServerUtils.ParseDWParamsURL(utf8decode(mb.DataString), VEncondig, DWParams{$IFDEF FPC}, vDatabaseCharSet{$ENDIF})
               Else
                TServerUtils.ParseDWParamsURL(mb.DataString, VEncondig, DWParams{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
              End;
             {Fim altera��o feita por Tiago Istuque - 28/12/2018}
            Finally
             mb.Free;
            End;
           End;
         End;
       End
      Else
       Begin
        aurlContext := urlContext;
        If Not (RequestType In [rtPut, rtPatch, rtDelete]) Then
         Begin
          {$IFDEF FPC}
          If ARequestInfo.FormParams <> '' Then
           Begin
            If Trim(ARequestInfo.QueryParams) <> '' Then
             Begin
              vRequestHeader.Add({$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF} + '?' + ARequestInfo.QueryParams + '&' + ARequestInfo.FormParams);
              TServerUtils.ParseRESTURL ({$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF} + '?' + ARequestInfo.QueryParams + '&' + ARequestInfo.FormParams, VEncondig, UrlMethod, urlContext, vmark{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}, DWParams);
             End
            Else
             Begin
              vRequestHeader.Add({$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF} + '?' + ARequestInfo.FormParams);
              TServerUtils.ParseRESTURL ({$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF} + '?' + ARequestInfo.FormParams, VEncondig, UrlMethod, urlContext, vmark{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}, DWParams);
              If DWParams.ItemsString['dwwelcomemessage'] <> Nil Then  // Ico Menezes - Post Receber WelcomeMessage   - 20-12-2018
               vWelcomeMessage := DecodeStrings(DWParams.ItemsString['dwwelcomemessage'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
             End;
           End
          Else
           Begin
            vRequestHeader.Add(ARequestInfo.Params.Text);
            vRequestHeader.Add({$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF});
            vRequestHeader.Add(ARequestInfo.QueryParams);
            TServerUtils.ParseWebFormsParams (ARequestInfo.Params, {$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF},
                                              ARequestInfo.QueryParams,
                                              UrlMethod, urlContext, vmark, VEncondig{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}, DWParams);
           End;
          {$ELSE}
          If ARequestInfo.FormParams <> '' Then
           Begin
            If Trim(ARequestInfo.QueryParams) <> '' Then
             Begin
              vRequestHeader.Add({$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF} + '?' + ARequestInfo.QueryParams + '&' + ARequestInfo.FormParams);
              TServerUtils.ParseRESTURL ({$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF} + '?' + ARequestInfo.QueryParams + '&' + ARequestInfo.FormParams, VEncondig, UrlMethod, urlContext, vmark, DWParams);
             End
            Else
             Begin
              vRequestHeader.Add({$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF} + '?' + ARequestInfo.FormParams);
              TServerUtils.ParseRESTURL ({$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF} + '?' + ARequestInfo.FormParams, VEncondig, UrlMethod, urlContext, vmark, DWParams);
              If DWParams.ItemsString['dwwelcomemessage'] <> Nil Then  // Ico Menezes - Post Receber WelcomeMessage   - 20-12-2018
               vWelcomeMessage := DecodeStrings(DWParams.ItemsString['dwwelcomemessage'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
             End;
           End
           Else
            Begin
             vRequestHeader.Add(ARequestInfo.Params.Text);
             vRequestHeader.Add({$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF});
             vRequestHeader.Add(ARequestInfo.QueryParams);
             If Not Assigned(DWParams) Then
              TServerUtils.ParseWebFormsParams (ARequestInfo.Params, {$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF},
                                                ARequestInfo.QueryParams,
                                                UrlMethod, urlContext, vmark, VEncondig, DWParams);
            End;
          {$ENDIF}
          If (DWParams.ItemsString['dwaccesstag'] <> Nil) Then
           vAccessTag := DecodeStrings(DWParams.ItemsString['dwaccesstag'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
         End
        Else
         Begin
          {$IFDEF FPC}
           vRequestHeader.Add(ARequestInfo.Params.Text);
           vRequestHeader.Add({$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF});
           vRequestHeader.Add(ARequestInfo.QueryParams);
           TServerUtils.ParseWebFormsParams (ARequestInfo.Params, {$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF},
                                             ARequestInfo.QueryParams,
                                             UrlMethod, urlContext, vmark, VEncondig{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}, DWParams);
          {$ELSE}
           vRequestHeader.Add(ARequestInfo.Params.Text);
           vRequestHeader.Add({$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF});
           vRequestHeader.Add(ARequestInfo.QueryParams);
           If Not Assigned(DWParams) Then
            TServerUtils.ParseWebFormsParams (ARequestInfo.Params, {$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF},
                                              ARequestInfo.QueryParams,
                                              UrlMethod, urlContext, vmark, VEncondig, DWParams);
          {$ENDIF}
         End;
        If (urlContext = '') And (aurlContext <> '') Then
         urlContext := aurlContext;
       End;
     End;
     WelcomeAccept := True;
     tmp           := '';
     If Assigned(vServerMethod) Then
      Begin
       If DWParams.ItemsString['dwwelcomemessage'] <> Nil Then
       vWelcomeMessage := DecodeStrings(DWParams.ItemsString['dwwelcomemessage'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
      If (DWParams.ItemsString['dwaccesstag'] <> Nil) Then
       vAccessTag := DecodeStrings(DWParams.ItemsString['dwaccesstag'].AsString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
      vTempServerMethods:= vServerMethod.Create(nil);
      vGettoken := False;
      If vServerBaseMethod = TServerMethods Then
       Begin
        TServerMethods(vTempServerMethods).SetClientWelcomeMessage(vWelcomeMessage);
        If TokenOptions.vActive Then
         Begin
          If (Assigned(TServerMethods(vTempServerMethods).OnGetToken) And
            ((Lowercase(UrlMethod) = 'gettoken') And (Trim(urlContext) = ''))) Then
           Begin
            TServerMethods(vTempServerMethods).OnGetToken(vWelcomeMessage, vAccessTag, DWParams, vToken, vDataBuff, vGettoken);
           End;
         End
        Else If Assigned(TServerMethods(vTempServerMethods).OnWelcomeMessage) then
         TServerMethods(vTempServerMethods).OnWelcomeMessage(vWelcomeMessage, vAccessTag, vdwConnectionDefs, WelcomeAccept, vContentType, vErrorMessage);
       End
      Else If vServerBaseMethod = TServerMethodDatamodule Then
       Begin
        TServerMethodDatamodule(vTempServerMethods).SetClientWelcomeMessage(vWelcomeMessage);
        If AContext.Connection.Socket.Binding.IPVersion = Id_IPv6 Then
         vIPVersion := 'ipv6';
        TServerMethodDatamodule(vTempServerMethods).SetClientInfo(AContext.Connection.Socket.Binding.PeerIP,
                                                                  vIPVersion,
                                                                  ARequestInfo.UserAgent,
                                                                  AContext.Connection.Socket.Binding.PeerPort);
        If (Assigned(TServerMethods(vTempServerMethods).OnGetToken) And
          ((Lowercase(UrlMethod) = 'gettoken') And (Trim(urlContext) = ''))) Then
         Begin
          TServerMethods(vTempServerMethods).OnGetToken(vWelcomeMessage, vAccessTag, DWParams, vToken, vDataBuff, vGettoken);
         End
        Else If Assigned(TServerMethodDatamodule(vTempServerMethods).OnWelcomeMessage) then
         TServerMethodDatamodule(vTempServerMethods).OnWelcomeMessage(vWelcomeMessage, vAccessTag, vdwConnectionDefs, WelcomeAccept, vContentType, vErrorMessage);
       End;
      End
     Else
      JSONStr := GetPairJSON(-5, 'Server Methods Cannot Assigned');
     Try
      If Assigned(vLastRequest) Then
       Begin
        If Not vMultiCORE Then
         Begin
          {$IFNDEF FPC}
           {$IF CompilerVersion > 21}
            {$IFDEF WINDOWS}
             if Not Assigned(vCriticalSection) Then
              vCriticalSection := TCriticalSection.Create;
             InitializeCriticalSection(vCriticalSection);
             EnterCriticalSection(vCriticalSection);
            {$ELSE}
             if Not Assigned(vCriticalSection) Then
              vCriticalSection := TCriticalSection.Create;
             vCriticalSection.Acquire;
            {$ENDIF}
           {$ELSE}
           if Not Assigned(vCriticalSection) Then
            vCriticalSection := TCriticalSection.Create;
           vCriticalSection.Acquire;
           {$IFEND}
          {$ELSE}
           InitCriticalSection(vCriticalSection);
           EnterCriticalSection(vCriticalSection);
          {$ENDIF}
         End;
        Try
         If Assigned(vLastRequest) Then
          vLastRequest(ARequestInfo.UserAgent + sLineBreak +
                      ARequestInfo.RawHTTPCommand);
        Finally
        If Not vMultiCORE Then
         Begin
          {$IFNDEF FPC}
           {$IF CompilerVersion > 21}
            {$IFDEF WINDOWS}
             If Assigned(vCriticalSection) Then
              Begin
               LeaveCriticalSection(vCriticalSection);
               DeleteCriticalSection(vCriticalSection);
              End;
            {$ELSE}
             If Assigned(vCriticalSection) Then
              Begin
               vCriticalSection.Release;
               FreeAndNil(vCriticalSection);
              End;
            {$ENDIF}
           {$ELSE}
            If Assigned(vCriticalSection) Then
             Begin
              vCriticalSection.Release;
              FreeAndNil(vCriticalSection);
             End;
           {$IFEND}
          {$ELSE}
           LeaveCriticalSection(vCriticalSection);
           DoneCriticalSection(vCriticalSection);
          {$ENDIF}
         End;
        End;
       End;
      If Assigned(vServerMethod) Then
       Begin
        If UrlMethod = '' Then
         Begin
          If {$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF} <> '' Then
           Begin
            UrlMethod := Trim({$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF});
            If UrlMethod <> '' Then
             If UrlMethod[InitStrPos] = '/' then
              Delete(UrlMethod, 1, 1);
            If Pos('/', UrlMethod) > 0 then
             Begin
              urlContext := Copy(UrlMethod, 1, Pos('/', UrlMethod) -1);
              UrlMethod  := Copy(UrlMethod, Pos('/', UrlMethod) +1, Length(UrlMethod));
             End;
           End
          Else
           Begin
            While (Length(UrlMethod) > 0) Do
             Begin
              If Pos('/', UrlMethod) > 0 then
               Delete(UrlMethod, 1, 1)
              Else
               Begin
                UrlMethod := Trim(UrlMethod);
                Break;
               End;
             End;
           End;
         End;
        If (UrlMethod = '') And (urlContext = '') Then
         UrlMethod := vOldMethod;
        vSpecialServer := False;
        If vTempServerMethods <> Nil Then
         Begin
          AResponseInfo.ContentType   := 'application/json'; //'text';//'application/octet-stream';
          If (UrlMethod = '') And (urlContext = '') Then
           Begin
            If vDefaultPage.Count > 0 Then
             vReplyString  := vDefaultPage.Text
            Else
             vReplyString  := TServerStatusHTML;
            vErrorCode   := 200;
            AResponseInfo.ContentType := 'text/html';
           End
          Else
           Begin
            If VEncondig = esUtf8 Then
             AResponseInfo.ContentEncoding       := 'utf-8'
            Else
             AResponseInfo.ContentEncoding       := 'ansi';
            If DWParams <> Nil Then
             Begin
              If DWParams.ItemsString['dwassyncexec'] <> Nil Then
               dwassyncexec := DWParams.ItemsString['dwassyncexec'].AsBoolean;
              If DWParams.ItemsString['dwusecript'] <> Nil Then
               vdwCriptKey  := DWParams.ItemsString['dwusecript'].AsBoolean;
             End;
            If dwassyncexec Then
             Begin
              AResponseInfo.ResponseNo               := 200;
              vReplyString                           := AssyncCommandMSG;
              {$IFNDEF FPC}
               If compresseddata Then
                mb                                  := TStringStream(ZCompressStreamNew(vReplyString))
               Else
                mb                                  := TStringStream.Create(vReplyString{$IFNDEF FPC}{$IF CompilerVersion > 21}, TEncoding.UTF8{$IFEND}{$ENDIF});
               mb.Position                          := 0;
               AResponseInfo.FreeContentStream      := True;
               AResponseInfo.ContentStream          := mb;
               AResponseInfo.ContentStream.Position := 0;
               AResponseInfo.ContentLength          := mb.Size;
               AResponseInfo.WriteContent;
              {$ELSE}
               If compresseddata Then
                mb                                  := TStringStream(ZCompressStreamNew(vReplyString)) //TStringStream.Create(Utf8Encode(vReplyStringResult))
               Else
                mb                                  := TStringStream.Create(vReplyString);
               mb.Position                          := 0;
               AResponseInfo.FreeContentStream      := True;
               AResponseInfo.ContentStream          := mb;
               AResponseInfo.ContentStream.Position := 0;
               AResponseInfo.ContentLength          := -1;//mb.Size;
               AResponseInfo.WriteContent;
              {$ENDIF}
             End;
            If DWParams.itemsstring['binaryRequest']        <> Nil Then
             vBinaryEvent := DWParams.itemsstring['binaryRequest'].Value;
            If DWParams.itemsstring['BinaryCompatibleMode'] <> Nil Then
             vBinaryCompatibleMode := DWParams.itemsstring['BinaryCompatibleMode'].Value;
            If DWParams.itemsstring['MetadataRequest']      <> Nil Then
             vMetadata := DWParams.itemsstring['MetadataRequest'].value;
            If (Assigned(DWParams)) And (Assigned(vCripto))        Then
             DWParams.SetCriptOptions(vdwCriptKey, vCripto.Key);
            If Not ServiceMethods(TComponent(vTempServerMethods), AContext, UrlMethod, urlContext, DWParams,
                                  JSONStr, JsonMode, vErrorCode,  vContentType, vServerContextCall, ServerContextStream,
                                  vdwConnectionDefs,  EncodeStrings, vAccessTag, WelcomeAccept, RequestType, vMark,
                                  vRequestHeader, vBinaryEvent, vMetadata, vBinaryCompatibleMode) Or (lowercase(vContentType) = 'application/php') Then
             Begin
              If Not dwassyncexec Then
               Begin
                {$IFNDEF FPC}
                 {$IF Defined(HAS_FMX)}
                  {$IFDEF WINDOWS}
                   If Assigned(CGIRunner) Then
                    Begin
                     If Pos('.php', UrlMethod) <> 0 then
                      Begin
                       vContentType := 'text/html';
                       LocalDoc := CGIRunner.PHPIniPath + CGIRunner.PHPModule;
                      End;
                     For I := 0 To CGIRunner.CGIExtensions.Count -1 Do
                      Begin
                       If Pos(LowerCase(CGIRunner.CGIExtensions[I]), LowerCase(aRequestInfo.Document)) <> 0 then
                        Begin
                         LocalDoc := ExpandFilename(FRootPath + aRequestInfo.Document);
                         Break;
                        End;
                      End;
                     If LocalDoc <> '' then
                      Begin
                       vSpecialServer := True;
                       If DWFileExists(LocalDoc) Then
                        Begin
                         CGIRunner.Execute(LocalDoc, AContext, aRequestInfo, aResponseInfo, FRootPath, JSONStr);
                         vTagReply := True;
                        End
                       Else
                        Begin
                         aResponseInfo.ContentText := '<H1><center>Script not found</center></H1>';
                         aResponseInfo.ResponseNo := 404; // Not found
                        End;
                      End;
                     End;
                  {$ENDIF}
                 {$ELSE}
                  If Assigned(CGIRunner) Then
                   Begin
                    If Pos('.php', UrlMethod) <> 0 then
                     Begin
                      vContentType := 'text/html';
                      LocalDoc := CGIRunner.PHPIniPath + CGIRunner.PHPModule;
                     End;
                    For I := 0 To CGIRunner.CGIExtensions.Count -1 Do
                     Begin
                      If Pos(LowerCase(CGIRunner.CGIExtensions[I]), LowerCase(aRequestInfo.Document)) <> 0 then
                       Begin
                        LocalDoc := ExpandFilename(FRootPath + aRequestInfo.Document);
                        Break;
                       End;
                     End;
                    If (LocalDoc <> '') or (lowercase(vContentType) = 'application/php') then
                     Begin
                      vSpecialServer := True;
                      If DWFileExists(LocalDoc, FRootPath) or (lowercase(vContentType) = 'application/php') Then
                       Begin
                        CGIRunner.Execute(LocalDoc, AContext, aRequestInfo, aResponseInfo, FRootPath, JSONStr);
                        vTagReply := True;
                       End
                      Else
                       Begin
                        aResponseInfo.ContentText := '<H1><center>Script not found</center></H1>';
                        aResponseInfo.ResponseNo := 404; // Not found
                       End;
                     End;
                    End;
                 {$IFEND}
                {$ENDIF}
                If Not vSpecialServer Then
                 Begin
                  If {$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF} <> '' Then
                   sFile := GetFileOSDir(ExcludeTag(tmp + {$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF}))
                  Else
                   sFile := GetFileOSDir(ExcludeTag(Cmd));
                  vFileExists := DWFileExists(sFile, FRootPath);
                  If Not vFileExists Then
                   Begin
                    tmp := '';
                    If ARequestInfo.Referer <> '' Then
                     tmp := GetLastMethod(ARequestInfo.Referer);
                    If {$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF} <> '' Then
                     sFile := GetFileOSDir(ExcludeTag(tmp + {$IFNDEF FPC}{$IF (DEFINED(OLDINDY))}ARequestInfo.Command{$ELSE}ARequestInfo.URI{$IFEND}{$ELSE}ARequestInfo.URI{$ENDIF}))
                    Else
                     sFile := GetFileOSDir(ExcludeTag(Cmd));
                    vFileExists := DWFileExists(sFile, FRootPath);
                   End;
                  vTagReply := vFileExists or scripttags(ExcludeTag(Cmd));
                  If vTagReply Then
                   Begin
                    AResponseInfo.FreeContentStream      := True;
                    AResponseInfo.ContentType            := GetMIMEType(sFile);
                    If scripttags(ExcludeTag(Cmd)) and Not vFileExists Then
                     AResponseInfo.ContentStream         := TMemoryStream.Create
                    Else
                     AResponseInfo.ContentStream         := TIdReadFileExclusiveStream.Create(sFile);
                    AResponseInfo.ContentStream.Position := 0;
                    AResponseInfo.ResponseNo             := 200;
                    AResponseInfo.WriteContent;
                   End;
                 End;
               End;
             End;
           End;
         End;
       End;
      Try
       If Assigned(vRequestHeader) Then
        Begin
         vRequestHeader.Clear;
         FreeAndNil(vRequestHeader);
        End;
       If Assigned(vServerMethod) Then
        If Assigned(vTempServerMethods) Then
         Begin
          Try
           {$IFDEF POSIX} //no linux nao precisa libertar porque � [weak]
           vTempServerMethods.free;
           {$ELSE}
           vTempServerMethods.free;
           vTempServerMethods := Nil;
           {$ENDIF}
          Except
          End;
         End;
       If Not dwassyncexec Then
        Begin
         If (Not (vTagReply)) Then
          Begin
           If VEncondig = esUtf8 Then
            AResponseInfo.Charset := 'utf-8'
           Else
            AResponseInfo.Charset := 'ansi';
           If vContentType <> '' Then
            AResponseInfo.ContentType := vContentType;
           If Not vServerContextCall Then
            Begin
             If (UrlMethod <> '') Then
              Begin
               If JsonMode in [jmDataware, jmUndefined] Then
                Begin
                 If Trim(JSONStr) <> '' Then
                  Begin
                   If Not(((Pos('{', JSONStr) > 0)   And
                           (Pos('}', JSONStr) > 0))  Or
                          ((Pos('[', JSONStr) > 0)   And
                           (Pos(']', JSONStr) > 0))) Then
                    Begin
                     If Not (WelcomeAccept) And (vErrorMessage <> '') Then
                       JSONStr := vErrorMessage
                     Else If Not((JSONStr[InitStrPos] = '"')  And
                            (JSONStr[Length(JSONStr)] = '"')) Then
                      JSONStr := '"' + JSONStr + '"';
                    End;
                  End;
                 If vBinaryEvent Then
                  Begin
                   vReplyString := JSONStr;
                   vErrorCode   := 200;
                  End
                 Else
                  Begin
                   If Not (WelcomeAccept) And (vErrorMessage <> '') Then
                    vReplyString := vErrorMessage
                   Else
                    vReplyString := Format(TValueDisp, [GetParamsReturn(DWParams), JSONStr]);
                  End;
                End
               Else If JsonMode = jmPureJSON Then
                Begin
                 If (Trim(JSONStr) = '') And (WelcomeAccept) Then
                  vReplyString := '{}'
                 Else If Not (WelcomeAccept) And (vErrorMessage <> '') Then
                  vReplyString := vErrorMessage
                 Else
                  vReplyString := JSONStr;
                End;
              End;
             AResponseInfo.ResponseNo                 := vErrorCode;
             If compresseddata Then
              Begin
               If vBinaryEvent Then
                Begin
                 ms := TStringStream.Create('');
                 Try
                  DWParams.SaveToStream(ms, tdwpxt_OUT);
                  ZCompressStreamD(ms, mb2);
                 Finally
                  FreeAndNil(ms);
                 End;
                End
               Else
                mb2                                   := ZCompressStreamNew(vReplyString);
               If vErrorCode <> 200 Then
                Begin
                 If Assigned(mb2) Then
                  FreeAndNil(mb2);
                 AResponseInfo.ResponseText           := aEncodeStrings(vReplyString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
                End
               Else
                Begin
                 AResponseInfo.FreeContentStream      := True;
                 mb2.Position := 0;
                 AResponseInfo.ContentStream          := mb2; //mb;
                End;
               If Assigned(AResponseInfo.ContentStream) Then
                Begin
                 AResponseInfo.ContentStream.Position := 0;
                 AResponseInfo.ContentLength          := AResponseInfo.ContentStream.Size;
                End
               Else
                AResponseInfo.ContentLength           := 0;
              End
             Else
              Begin
               {$IFNDEF FPC}
                {$IF CompilerVersion > 21}
                 If vBinaryEvent Then
                  Begin
                   mb := TStringStream.Create('');
                   Try
                    DWParams.SaveToStream(mb, tdwpxt_OUT);
                   Finally
                   End;
                  End
                 Else
                  mb                                  := TStringStream.Create(vReplyString{$IFNDEF FPC}{$IF CompilerVersion > 21}, TEncoding.UTF8{$IFEND}{$ENDIF});
                 mb.Position                          := 0;
                 AResponseInfo.FreeContentStream      := True;
                 AResponseInfo.ContentStream          := mb;
                 AResponseInfo.ContentStream.Position := 0;
                 AResponseInfo.ContentLength          := mb.Size;
                {$ELSE}
                 If vBinaryEvent Then
                  Begin
                   mb := TStringStream.Create('');
                   Try
                    DWParams.SaveToStream(mb, tdwpxt_OUT);
                   Finally
                   End;
                   AResponseInfo.FreeContentStream      := True;
                   AResponseInfo.ContentStream          := mb;
                   AResponseInfo.ContentStream.Position := 0;
                   AResponseInfo.ContentLength          := mb.Size;
                  End
                 Else
                  Begin
                   AResponseInfo.ContentLength          := -1;
                   AResponseInfo.ContentText            := vReplyString;
                   AResponseInfo.WriteHeader;
                  End;
                {$IFEND}
               {$ELSE}
                If vBinaryEvent Then
                 Begin
                  mb := TStringStream.Create('');
                  Try
                   DWParams.SaveToStream(mb, tdwpxt_OUT);
                  Finally
                  End;
                  AResponseInfo.FreeContentStream       := True;
                  AResponseInfo.ContentStream           := mb;
                  AResponseInfo.ContentStream.Position  := 0;
                  AResponseInfo.ContentLength           := mb.Size;
                 End
                Else
                 Begin
                  If VEncondig = esUtf8 Then
                   mb                                   := TStringStream.Create(Utf8Encode(vReplyString))
                  Else
                   mb                                   := TStringStream.Create(vReplyString);
                  mb.Position                           := 0;
                  AResponseInfo.FreeContentStream       := True;
                  AResponseInfo.ContentStream           := mb;
                  AResponseInfo.ContentStream.Position  := 0;
                  AResponseInfo.ContentLength           := mb.Size;
                  AResponseInfo.WriteHeader;
                 End;
               {$ENDIF}
              End;
            End
           Else
            Begin
             LocalDoc := '';
             If TEncodeSelect(VEncondig) = esUtf8 Then
              AResponseInfo.Charset := 'utf-8'
              Else If TEncodeSelect(VEncondig) in [esANSI, esASCII] Then
              AResponseInfo.Charset := 'ansi';
             If Not vSpecialServer Then
              Begin
               AResponseInfo.ResponseNo             := vErrorCode;
               If ServerContextStream <> Nil Then
                Begin
                 AResponseInfo.FreeContentStream        := True;
                 AResponseInfo.ContentStream            := ServerContextStream;
                 AResponseInfo.ContentStream.Position   := 0;
                 AResponseInfo.ContentLength            := ServerContextStream.Size;
                End
               Else
                Begin
                 {$IFDEF FPC}
                   If VEncondig = esUtf8 Then
                    mb                                  := TStringStream.Create(Utf8Encode(JSONStr))
                   Else
                    mb                                  := TStringStream.Create(JSONStr);
                  mb.Position                           := 0;
                  AResponseInfo.FreeContentStream       := True;
                  AResponseInfo.ContentStream           := mb;
                  AResponseInfo.ContentStream.Position  := 0;
                  AResponseInfo.ContentLength           := -1;//mb.Size;
                 {$ELSE}
                  {$IF CompilerVersion > 21}
                   mb                                   := TStringStream.Create(JSONStr{$IFNDEF FPC}{$IF CompilerVersion > 21}, TEncoding.UTF8{$IFEND}{$ENDIF});
                   mb.Position                          := 0;
                   AResponseInfo.FreeContentStream      := True;
                   AResponseInfo.ContentStream          := mb;
                   AResponseInfo.ContentStream.Position := 0;
                   AResponseInfo.ContentLength          := mb.Size;
                  {$ELSE}
                   AResponseInfo.ContentLength          := -1;
                   AResponseInfo.ContentText            := JSONStr;
                  {$IFEND}
                 {$ENDIF}
                End;
              End;
            End;
            If Not AResponseInfo.HeaderHasBeenWritten Then
             If AResponseInfo.CustomHeaders.Count > 0 Then
              AResponseInfo.WriteHeader;
            If Not (vBinaryEvent) Then
             If (Assigned(AResponseInfo.ContentStream)) Then
              If AResponseInfo.ContentStream.size > 0   Then
               AResponseInfo.WriteContent;
          End;
        End;
      Finally
//        FreeAndNil(mb);
      End;
      If Assigned(vLastResponse) Then
       Begin
        If Not vMultiCORE Then
         Begin
          {$IFNDEF FPC}
           {$IF CompilerVersion > 21}
            {$IFDEF WINDOWS}
             InitializeCriticalSection(vCriticalSection);
             EnterCriticalSection(vCriticalSection);
            {$ELSE}
             If Not Assigned(vCriticalSection) Then
              vCriticalSection := TCriticalSection.Create;
             vCriticalSection.Acquire;
            {$ENDIF}
           {$ELSE}
            If Not Assigned(vCriticalSection)  Then
             vCriticalSection := TCriticalSection.Create;
            vCriticalSection.Acquire;
           {$IFEND}
          {$ELSE}
           InitCriticalSection(vCriticalSection);
           EnterCriticalSection(vCriticalSection);
          {$ENDIF}
         End;
        Try
         vLastResponse(vReplyString);
        Finally
         If Not vMultiCORE Then
          Begin
           {$IFNDEF FPC}
            {$IF CompilerVersion > 21}
             {$IFDEF WINDOWS}
              LeaveCriticalSection(vCriticalSection);
              DeleteCriticalSection(vCriticalSection);
             {$ELSE}
              vCriticalSection.Release;
              FreeAndNil(vCriticalSection);
             {$ENDIF}
            {$ELSE}
              vCriticalSection.Release;
              FreeAndNil(vCriticalSection);
            {$IFEND}
           {$ELSE}
            LeaveCriticalSection(vCriticalSection);
            DoneCriticalSection(vCriticalSection);
           {$ENDIF}
          End;
        End;
       End;
     Finally
      If Assigned(vServerMethod) Then
       If Assigned(vTempServerMethods) Then
        Begin
         Try
          {$IFDEF POSIX} //no linux nao precisa libertar porque � [weak]
          {$ELSE}
          FreeAndNil(vTempServerMethods); //.free;
          {$ENDIF}
         Except
         End;
        End;
     End;
   End;
 Finally
  If Assigned(DWParams) Then
   FreeAndNil(DWParams);
  If Assigned(vdwConnectionDefs) Then
   FreeAndNil(vdwConnectionDefs);
  If Assigned(vRequestHeader)    Then
   FreeAndNil(vRequestHeader);
 End;
End;

Procedure TRESTServicePooler.aCommandOther(AContext      : TIdContext;
                                           ARequestInfo  : TIdHTTPRequestInfo;
                                           AResponseInfo : TIdHTTPResponseInfo);
Begin
 aCommandGet(AContext, ARequestInfo, AResponseInfo);
end;

{$IFDEF FPC}
{$ELSE}
{$IF Defined(HAS_FMX)}
{$IFDEF WINDOWS}
Procedure TRESTServicePooler.SetISAPIRunner(Value : TDWISAPIRunner);
Begin
 If Assigned(vDWISAPIRunner) And (Value = Nil) Then
  vDWISAPIRunner.Server := Nil;
 vDWISAPIRunner := Value;
 If Assigned(vDWISAPIRunner) Then
  vDWISAPIRunner.Server := HTTPServer;
 If vDWISAPIRunner <> Nil then
  vDWISAPIRunner.FreeNotification(Self);
End;

Procedure TRESTServicePooler.SetCGIRunner  (Value : TDWCGIRunner);
Begin
 If Assigned(vDWCGIRunner) And (Value = Nil) Then
  vDWCGIRunner.Server := Nil;
 vDWCGIRunner := Value;
 If Assigned(vDWCGIRunner) Then
   vDWCGIRunner.Server := HTTPServer;
 If vDWCGIRunner <> Nil    Then
   vDWCGIRunner.FreeNotification(Self);
End;
{$ENDIF}
{$ELSE}
Procedure TRESTServicePooler.SetISAPIRunner(Value : TDWISAPIRunner);
Begin
 If Assigned(vDWISAPIRunner) And (Value = Nil) Then
  vDWISAPIRunner.Server := Nil;
 vDWISAPIRunner := Value;
 If Assigned(vDWISAPIRunner) Then
  vDWISAPIRunner.Server := HTTPServer;
 If vDWISAPIRunner <> Nil    Then
  vDWISAPIRunner.FreeNotification(Self);
End;

Procedure TRESTServicePooler.SetCGIRunner  (Value : TDWCGIRunner);
Begin
 If Assigned(vDWCGIRunner) And (Value = Nil) Then
  vDWCGIRunner.Server := Nil;
 vDWCGIRunner := Value;
 If Assigned(vDWCGIRunner) Then
  vDWCGIRunner.Server := HTTPServer;
 If vDWCGIRunner <> Nil Then
  vDWCGIRunner.FreeNotification(Self);
End;
{$IFEND}
{$ENDIF}

procedure TRESTServicePooler.SetRESTServiceNotification(
  Value: TRESTDWServiceNotification);
begin
 If Value <> Nil Then
  vRESTServiceNotification := Value;
 If vRESTServiceNotification <> Nil Then
  vRESTServiceNotification.FreeNotification(Self);
end;

Constructor TRESTServicePooler.Create(AOwner: TComponent);
Begin
 Inherited;
 vProxyOptions                   := TProxyOptions.Create;
 vTokenOptions                   := TServerTokenOptions.Create;
 vDefaultPage                    := TStringList.Create;
 vCORSCustomHeaders              := TStringList.Create;
 vCORSCustomHeaders.Add('Access-Control-Allow-Origin=*');
 vCORSCustomHeaders.Add('Access-Control-Allow-Methods=GET, POST, PATCH, PUT, DELETE, OPTIONS');
 vCORSCustomHeaders.Add('Access-Control-Allow-Headers=Content-Type, Origin, Accept, Authorization, X-CUSTOM-HEADER');
 vCripto                         := TCripto.Create;
 HTTPServer                      := TIdHTTPServer.Create(Nil);
 lHandler                        := TIdServerIOHandlerSSLOpenSSL.Create;
 {$IFDEF FPC}
 HTTPServer.OnQuerySSLPort       := @IdHTTPServerQuerySSLPort;
 HTTPServer.OnCommandGet         := @aCommandGet;
 HTTPServer.OnCommandOther       := @aCommandOther;
 HTTPServer.OnConnect            := @CustomOnConnect;
 vDatabaseCharSet                := csUndefined;
 {$ELSE}
 HTTPServer.OnQuerySSLPort       := IdHTTPServerQuerySSLPort;
 HTTPServer.OnCommandGet         := aCommandGet;
 HTTPServer.OnCommandOther       := aCommandOther;
 HTTPServer.OnConnect            := CustomOnConnect;
 {$ENDIF}
 vServerParams                   := TServerParams.Create(Self);
 vActive                         := False;
 vServerParams.HasAuthentication := True;
 vServerParams.UserName          := 'testserver';
 vServerParams.Password          := 'testserver';
 vServerContext                  := 'restdataware';
 VEncondig                       := esUtf8;
 vServicePort                    := 8082;
 vForceWelcomeAccess             := False;
 vCORS                           := False;
 vMultiCORE                      := False;
 FRootPath                       := '/';
 vASSLRootCertFile               := '';
 HTTPServer.MaxConnections       := -1;
 vServiceTimeout                 := -1;
End;

Procedure TRESTServicePooler.CustomOnConnect(AContext : TIdContext);
Begin
 AContext.Connection.Socket.ReadTimeout := vServiceTimeout;
End;

Destructor TRESTServicePooler.Destroy;
Begin
 FreeAndNil(vProxyOptions);
 FreeAndNil(vTokenOptions);
 FreeAndNil(vCripto);
 FreeAndNil(vDefaultPage);
 FreeAndNil(vCORSCustomHeaders);
 HTTPServer.Active := False;
 HTTPServer.Free;
 vServerParams.Free;
 lHandler.Free;
 Inherited;
End;

Function TRESTServicePooler.GetSecure : Boolean;
Begin
 Result:= vActive And (HTTPServer.IOHandler is TIdServerIOHandlerSSLBase);
End;

Procedure TRESTServicePooler.GetSSLPassWord(var Password: {$IFNDEF FPC}{$IF (CompilerVersion = 23) OR (CompilerVersion = 24) OR (DEFINED(OLDINDY))}
                                                                                     AnsiString
                                                                                    {$ELSE}
                                                                                     String
                                                                                    {$IFEND}
                                                                                    {$ELSE}
                                                                                     String
                                                                                    {$ENDIF});
Begin
 Password := aSSLPrivateKeyPassword;
End;

Procedure TRESTServicePooler.SetActive(Value : Boolean);
Begin
 If (Value)                   And
    (Not (HTTPServer.Active)) Then
  Begin
   Try
    If (ASSLPrivateKeyFile <> '')     And
       (ASSLPrivateKeyPassword <> '') And
       (ASSLCertFile <> '')           Then
     Begin
      lHandler.SSLOptions.Method                := aSSLMethod;
      {$IFDEF FPC}
      lHandler.SSLOptions.SSLVersions           :=aSSLVersions;
      lHandler.OnGetPassword                    := @GetSSLPassword;
      lHandler.OnVerifyPeer                     := @SSLVerifyPeer;
      {$ELSE}
       {$IF Not(DEFINED(OLDINDY))}
        lHandler.SSLOptions.SSLVersions         := aSSLVersions;
        lHandler.OnVerifyPeer                   := SSLVerifyPeer;
       {$IFEND}
      lHandler.OnGetPassword                    := GetSSLPassword;
      {$ENDIF}
      lHandler.SSLOptions.CertFile              := ASSLCertFile;
      lHandler.SSLOptions.KeyFile               := ASSLPrivateKeyFile;
      lHandler.SSLOptions.VerifyMode            := vSSLVerifyMode;
      lHandler.SSLOptions.VerifyDepth           := vSSLVerifyDepth;
      lHandler.SSLOptions.RootCertFile          := vASSLRootCertFile;
      HTTPServer.IOHandler := lHandler;
     End
    Else
     HTTPServer.IOHandler  := Nil;
    If HTTPServer.Bindings.Count > 0 Then
     HTTPServer.Bindings.Clear;
    HTTPServer.Bindings.DefaultPort := vServicePort;
    HTTPServer.DefaultPort          := vServicePort;
    HTTPServer.Active               := True;
   Except
    On E : Exception do
     Begin
      Raise Exception.Create(PChar(E.Message));
     End;
   End;
  End
 Else If Not(Value) Then
  HTTPServer.Active := False;
 vActive := HTTPServer.Active;
End;

Procedure TRESTServicePooler.Loaded;
Begin
 Inherited;
 If Assigned(vOnCreate) Then
  vOnCreate(Self);
End;

Procedure TRESTServicePooler.SetServerMethod(Value : TComponentClass);
Begin
 If (Value.ClassParent      = TServerMethods) Or
    (Value                  = TServerMethods) Then
  vServerMethod     := Value
 Else If (Value.ClassParent = TServerMethodDatamodule) Or
         (Value             = TServerMethodDatamodule) Then
  vServerMethod := Value;
End;

Function  TRESTServicePooler.SSLVerifyPeer (Certificate : TIdX509; AOk : Boolean; ADepth, AError : Integer) : Boolean;

Begin
 If ADepth = 0 Then
  Result := AOk
 Else
  Result := True;
End;

{ TRESTDWServiceNotification }

Constructor TRESTDWServiceNotification.Create(AOwner : TComponent);
Begin
 Inherited;
 vGarbageTime        := 60000;
 vQueueNotifications := 50;
End;

Destructor TRESTDWServiceNotification.Destroy;
Begin

 Inherited;
End;

Function TRESTDWServiceNotification.GetAccessTag : String;
Begin
 Result := vAccessTag;
End;

Function TRESTDWServiceNotification.GetNotifications(LastNotification : String) : String;
Begin

End;

Procedure TRESTDWServiceNotification.SetAccessTag(Value : String);
Begin
 vAccessTag := Value;
End;

end.


