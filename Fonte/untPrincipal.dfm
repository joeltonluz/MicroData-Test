object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Gerenciamento de Clientes'
  ClientHeight = 443
  ClientWidth = 657
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PgcCliente: TPageControl
    Left = 0
    Top = 49
    Width = 657
    Height = 335
    ActivePage = TshTabela
    Align = alClient
    Style = tsButtons
    TabOrder = 0
    OnChanging = PgcClienteChanging
    object TshTabela: TTabSheet
      Caption = 'Tabela'
      object DBGrid1: TDBGrid
        Left = 0
        Top = 20
        Width = 649
        Height = 284
        Align = alClient
        DataSource = PrincipalM.DtsCliente
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnDblClick = DBGrid1DblClick
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            Title.Caption = 'Id'
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NOME'
            Title.Caption = 'Nome'
            Width = 300
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CIDADE'
            Title.Caption = 'Cidade'
            Width = 200
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SIGLA_UF'
            Title.Caption = 'UF'
            Width = 40
            Visible = True
          end>
      end
      object PnlTopoCliente: TPanel
        Left = 0
        Top = 0
        Width = 649
        Height = 20
        Align = alTop
        Caption = 'Selecione ou Duplo Clique para Informa'#231#245'es do Cliente'
        TabOrder = 1
      end
    end
    object TshInformacao: TTabSheet
      Caption = 'Informa'#231#227'o do Cliente'
      ImageIndex = 1
      DesignSize = (
        649
        304)
      object LblId: TLabel
        Left = 8
        Top = 8
        Width = 11
        Height = 13
        Caption = 'ID'
      end
      object Label1: TLabel
        Left = 90
        Top = 8
        Width = 29
        Height = 13
        Caption = 'NOME'
      end
      object Label2: TLabel
        Left = 8
        Top = 56
        Width = 19
        Height = 13
        Caption = 'CEP'
      end
      object Label3: TLabel
        Left = 87
        Top = 56
        Width = 13
        Height = 13
        Caption = 'UF'
      end
      object Label4: TLabel
        Left = 135
        Top = 56
        Width = 38
        Height = 13
        Caption = 'CIDADE'
      end
      object Label5: TLabel
        Left = 288
        Top = 56
        Width = 71
        Height = 13
        Caption = 'LOGRADOURO'
      end
      object Label6: TLabel
        Left = 8
        Top = 104
        Width = 43
        Height = 13
        Caption = 'N'#218'MERO'
      end
      object Label7: TLabel
        Left = 288
        Top = 104
        Width = 75
        Height = 13
        Caption = 'COMPLEMENTO'
      end
      object Label8: TLabel
        Left = 87
        Top = 104
        Width = 39
        Height = 13
        Caption = 'UF IBGE'
      end
      object Label9: TLabel
        Left = 135
        Top = 104
        Width = 64
        Height = 13
        Caption = 'CIDADE IBGE'
      end
      object DBEdit1: TDBEdit
        Left = 8
        Top = 24
        Width = 73
        Height = 21
        CharCase = ecUpperCase
        DataField = 'ID'
        DataSource = PrincipalM.DtsCliente
        ReadOnly = True
        TabOrder = 0
      end
      object DBEdit2: TDBEdit
        Left = 87
        Top = 24
        Width = 553
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        CharCase = ecUpperCase
        DataField = 'NOME'
        DataSource = PrincipalM.DtsCliente
        TabOrder = 1
      end
      object EdtCep: TDBEdit
        Left = 8
        Top = 72
        Width = 73
        Height = 21
        CharCase = ecUpperCase
        DataField = 'CEP'
        DataSource = PrincipalM.DtsCliente
        TabOrder = 2
        OnExit = EdtCepExit
      end
      object DBEdit4: TDBEdit
        Left = 135
        Top = 72
        Width = 147
        Height = 21
        CharCase = ecUpperCase
        DataField = 'CIDADE'
        DataSource = PrincipalM.DtsCliente
        TabOrder = 4
      end
      object DBEdit5: TDBEdit
        Left = 288
        Top = 72
        Width = 352
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        CharCase = ecUpperCase
        DataField = 'LOGRADOURO'
        DataSource = PrincipalM.DtsCliente
        TabOrder = 5
      end
      object EdtNumero: TDBEdit
        Left = 8
        Top = 120
        Width = 73
        Height = 21
        CharCase = ecUpperCase
        DataField = 'NUMERO'
        DataSource = PrincipalM.DtsCliente
        TabOrder = 6
      end
      object DBEdit7: TDBEdit
        Left = 288
        Top = 120
        Width = 352
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        CharCase = ecUpperCase
        DataField = 'COMPLEMENTO'
        DataSource = PrincipalM.DtsCliente
        TabOrder = 9
      end
      object DBEdit8: TDBEdit
        Left = 87
        Top = 120
        Width = 42
        Height = 21
        CharCase = ecUpperCase
        DataField = 'IBGE_UF'
        DataSource = PrincipalM.DtsCliente
        TabOrder = 7
      end
      object DBEdit9: TDBEdit
        Left = 135
        Top = 120
        Width = 147
        Height = 21
        CharCase = ecUpperCase
        DataField = 'IBGE_CIDADE'
        DataSource = PrincipalM.DtsCliente
        TabOrder = 8
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 147
        Width = 632
        Height = 154
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = ' CONTATOS '
        TabOrder = 10
        object DBGrid2: TDBGrid
          Left = 2
          Top = 56
          Width = 628
          Height = 96
          Align = alClient
          DataSource = PrincipalM.DtsContato
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'ID'
              ReadOnly = True
              Title.Caption = 'Id'
              Width = 60
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'NOME'
              Title.Caption = 'Nome'
              Width = 280
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DATA_NASC'
              Title.Caption = 'Nascimento'
              Width = 70
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'IDADE'
              ReadOnly = True
              Title.Caption = 'Idade'
              Width = 50
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'TELEFONE'
              Title.Caption = 'Telefone'
              Width = 100
              Visible = True
            end>
        end
        object Panel1: TPanel
          Left = 2
          Top = 15
          Width = 628
          Height = 41
          Align = alTop
          Caption = 'Panel1'
          TabOrder = 1
          object DBNavigator2: TDBNavigator
            AlignWithMargins = True
            Left = 5
            Top = 5
            Width = 400
            Height = 31
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 0
            Margins.Bottom = 4
            DataSource = PrincipalM.DtsContato
            Align = alLeft
            TabOrder = 0
          end
        end
      end
      object DBComboBox1: TDBComboBox
        Left = 87
        Top = 72
        Width = 42
        Height = 21
        DataField = 'SIGLA_UF'
        DataSource = PrincipalM.DtsCliente
        Items.Strings = (
          'AC'
          'AL'
          'AM'
          'AP'
          'BA'
          'CE'
          'DF'
          'ES'
          'GO'
          'MA'
          'MG'
          'MS'
          'MT'
          'PA'
          'PB'
          'PE'
          'PI'
          'PR'
          'RJ'
          'RN'
          'RO'
          'RR'
          'RS'
          'SC'
          'SE'
          'SP'
          'TO')
        TabOrder = 3
      end
      object DBEdit3: TDBEdit
        Left = 87
        Top = 72
        Width = 42
        Height = 21
        CharCase = ecUpperCase
        DataField = 'SIGLA_UF'
        DataSource = PrincipalM.DtsCliente
        TabOrder = 11
      end
    end
  end
  object PnlMenu: TPanel
    Left = 0
    Top = 0
    Width = 657
    Height = 49
    Align = alTop
    TabOrder = 1
    object DBNavigator1: TDBNavigator
      AlignWithMargins = True
      Left = 5
      Top = 5
      Width = 448
      Height = 39
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 0
      Margins.Bottom = 4
      DataSource = PrincipalM.DtsCliente
      Align = alLeft
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 384
    Width = 657
    Height = 59
    Align = alBottom
    TabOrder = 2
    ExplicitTop = 386
    object Label10: TLabel
      Left = 16
      Top = 6
      Width = 236
      Height = 16
      Caption = 'LIGAR SERVIDOR PARA TESTE DE API'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label11: TLabel
      Left = 85
      Top = 33
      Width = 261
      Height = 13
      Caption = 'http://localhost:9000/cliente?nome=NOMEDOCLIENTE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsItalic]
      ParentFont = False
      Visible = False
    end
    object Label12: TLabel
      Left = 472
      Top = 22
      Width = 146
      Height = 13
      Caption = 'Usu'#225'rio: admin | Senha: admin'
      Visible = False
    end
    object ToggleSwitch: TToggleSwitch
      Left = 16
      Top = 28
      Width = 62
      Height = 20
      SwitchWidth = 40
      TabOrder = 0
      OnClick = ToggleSwitchClick
    end
  end
  object RESTServicePooler1: TRESTServicePooler
    Active = False
    CORS = False
    CORS_CustomHeaders.Strings = (
      'Access-Control-Allow-Origin=*'
      
        'Access-Control-Allow-Methods=GET, POST, PATCH, PUT, DELETE, OPTI' +
        'ONS'
      
        'Access-Control-Allow-Headers=Content-Type, Origin, Accept, Autho' +
        'rization, X-CUSTOM-HEADER')
    RequestTimeout = -1
    ServicePort = 9000
    ProxyOptions.Port = 8888
    TokenOptions.Active = False
    TokenOptions.ServerRequest = 'RESTDWServer01'
    TokenOptions.TokenHash = 'RDWTS_HASH'
    TokenOptions.LifeCycle = 30
    ServerParams.HasAuthentication = True
    ServerParams.UserName = 'admin'
    ServerParams.Password = 'admin'
    SSLMethod = sslvSSLv2
    SSLVersions = []
    Encoding = esUtf8
    ServerContext = 'restdataware'
    RootPath = '/'
    SSLVerifyMode = []
    SSLVerifyDepth = 0
    ForceWelcomeAccess = False
    CriptOptions.Use = False
    CriptOptions.Key = 'RDWBASEKEY256'
    MultiCORE = False
    Left = 384
    Top = 392
  end
end
