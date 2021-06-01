object dtmServerRestDW: TdtmServerRestDW
  OldCreateOrder = False
  Encoding = esUtf8
  Height = 399
  Width = 369
  object DWEvents: TDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'nome'
            Encoded = False
          end>
        JsonMode = jmPureJSON
        Name = 'cliente'
        OnReplyEvent = DWEventsEventsclientesReplyEvent
      end>
    Left = 168
    Top = 184
  end
end
