object PrincipalM: TPrincipalM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 321
  Width = 511
  object connPrincipal: TZConnection
    ControlsCodePage = cCP_UTF16
    AutoEncodeStrings = True
    Catalog = ''
    HostName = ''
    Port = 3050
    Database = 'C:\_Dev\MicroData-Test\Database\db.fdb'
    User = 'SYSDBA'
    Password = 'masterkey'
    Protocol = 'firebird-3.0'
    Left = 56
    Top = 24
  end
  object QryCliente: TZQuery
    Connection = connPrincipal
    AfterPost = QryClienteAfterPost
    BeforeDelete = QryClienteBeforeDelete
    SQL.Strings = (
      'SELECT'
      '  ID,'
      '  NOME,'
      '  CEP,'
      '  LOGRADOURO,'
      '  NUMERO,'
      '  COMPLEMENTO,'
      '  CIDADE,'
      '  IBGE_CIDADE,'
      '  SIGLA_UF,'
      '  IBGE_UF'
      '  FROM'
      'CLIENTE')
    Params = <>
    Left = 128
    Top = 80
    object QryClienteID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object QryClienteNOME: TWideStringField
      FieldName = 'NOME'
      Required = True
      Size = 50
    end
    object QryClienteCEP: TWideStringField
      FieldName = 'CEP'
      Required = True
      EditMask = '99999-999;1;_'
      Size = 10
    end
    object QryClienteLOGRADOURO: TWideStringField
      FieldName = 'LOGRADOURO'
      Required = True
      Size = 60
    end
    object QryClienteNUMERO: TWideStringField
      FieldName = 'NUMERO'
      Required = True
      Size = 10
    end
    object QryClienteCOMPLEMENTO: TWideStringField
      FieldName = 'COMPLEMENTO'
      Required = True
      Size = 40
    end
    object QryClienteCIDADE: TWideStringField
      FieldName = 'CIDADE'
      Required = True
      Size = 40
    end
    object QryClienteIBGE_CIDADE: TWideStringField
      FieldName = 'IBGE_CIDADE'
      Required = True
      Size = 7
    end
    object QryClienteSIGLA_UF: TWideStringField
      FieldName = 'SIGLA_UF'
      Required = True
      Size = 2
    end
    object QryClienteIBGE_UF: TWideStringField
      FieldName = 'IBGE_UF'
      Required = True
      Size = 2
    end
  end
  object DtsCliente: TDataSource
    DataSet = QryCliente
    Left = 56
    Top = 80
  end
  object DtsContato: TDataSource
    DataSet = QryContato
    Left = 56
    Top = 136
  end
  object QryContato: TZQuery
    Connection = connPrincipal
    BeforeInsert = QryContatoBeforeInsert
    BeforePost = QryContatoBeforePost
    AfterPost = QryContatoAfterPost
    SQL.Strings = (
      'select * from contato where id_cliente = :id')
    Params = <
      item
        DataType = ftUnknown
        Name = 'id'
        ParamType = ptUnknown
      end>
    DataSource = DtsCliente
    Left = 128
    Top = 136
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'id'
        ParamType = ptUnknown
      end>
    object QryContatoID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object QryContatoNOME: TWideStringField
      FieldName = 'NOME'
      Required = True
      Size = 50
    end
    object QryContatoDATA_NASC: TDateTimeField
      FieldName = 'DATA_NASC'
      EditMask = '99/99/9999;1;_'
    end
    object QryContatoIDADE: TIntegerField
      FieldName = 'IDADE'
    end
    object QryContatoTELEFONE: TWideStringField
      FieldName = 'TELEFONE'
      EditMask = '(99) 99999-9999;1;_'
      Size = 15
    end
    object QryContatoID_CLIENTE: TIntegerField
      FieldName = 'ID_CLIENTE'
    end
  end
  object RESTClient1: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'https://api.postmon.com.br/v1/cep'
    Params = <>
    RaiseExceptionOn500 = False
    Left = 304
    Top = 8
  end
  object RESTRequest1: TRESTRequest
    Client = RESTClient1
    Params = <>
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 304
    Top = 64
  end
  object RESTResponse1: TRESTResponse
    ContentType = 'application/json'
    Left = 304
    Top = 112
  end
  object RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter
    Active = True
    Dataset = FDMemTable1
    FieldDefs = <>
    Response = RESTResponse1
    Left = 304
    Top = 168
  end
  object FDMemTable1: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'bairro'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'cidade'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'logradouro'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'estado_info'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'cep'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'cidade_info'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'estado'
        DataType = ftWideString
        Size = 255
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 304
    Top = 216
    object FDMemTable1bairro: TWideStringField
      FieldName = 'bairro'
      Size = 255
    end
    object FDMemTable1cidade: TWideStringField
      FieldName = 'cidade'
      Size = 255
    end
    object FDMemTable1logradouro: TWideStringField
      FieldName = 'logradouro'
      Size = 255
    end
    object FDMemTable1estado_info: TWideStringField
      FieldName = 'estado_info'
      Size = 255
    end
    object FDMemTable1cep: TWideStringField
      FieldName = 'cep'
      Size = 255
    end
    object FDMemTable1cidade_info: TWideStringField
      FieldName = 'cidade_info'
      Size = 255
    end
    object FDMemTable1estado: TWideStringField
      FieldName = 'estado'
      Size = 255
    end
  end
end
