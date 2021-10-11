object ChatRL: TChatRL
  Left = 51
  Top = -18
  Anchors = []
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  ClientHeight = 77
  ClientWidth = 148
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 148
    Height = 77
    ActivePage = TabSheetServeur
    Align = alClient
    TabOrder = 0
    OnChanging = PageControlChanging
    object TabSheetServeur: TTabSheet
      Caption = 'SERVEUR'
      OnShow = TabSheetServeurShow
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 145
        Height = 49
        Align = alCustom
        TabOrder = 0
        DesignSize = (
          145
          49)
        object LabelIP: TLabel
          Left = 168
          Top = 24
          Width = 5
          Height = 13
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object BitBtnLancerS: TBitBtn
          Left = 11
          Top = 12
          Width = 121
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Lancer le Serveur'
          TabOrder = 0
          OnClick = BitBtnLancerSClick
          Glyph.Data = {
            66010000424D6601000000000000760000002800000014000000140000000100
            040000000000F000000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
            00333333000030FFFFFFFFFFF03333330000330F0F0F0F0F0333333300000000
            FFFFFFF00003333300000FF800000008FF03333300000F9FFFFFFFF000033333
            00000FFFFFFFFFFFFF0333330000300000000000003333330000333000000000
            3333333300003330FFFF00703333333300003330F0000B307833333300003330
            F0CCC0BB0078333300003330F0CCC00BB300733300003330F00000F0BBB00733
            00003330FFFFFFF00BBB00830000333000000000BBB008330000333333333330
            0BBB00830000333333333333300BB008000033333333333333300B0000003333
            33333333333330000000}
        end
      end
    end
  end
  object ServerSocket: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnAccept = ServerSocketAccept
    OnClientConnect = ServerSocketClientConnect
    OnClientDisconnect = ServerSocketClientDisconnect
    OnClientRead = ServerSocketClientRead
    OnClientError = ServerSocketClientError
    Left = 36
    Top = 28
  end
  object TimerInformationsChateur: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = TimerInformationsChateurTimer
    Left = 64
    Top = 28
  end
  object TimerNombresClientsActuels: TTimer
    Interval = 100
    Left = 92
    Top = 28
  end
end
