object ChoixCouleur: TChoixCouleur
  Left = 219
  Top = 181
  Width = 495
  Height = 316
  BorderIcons = [biMinimize, biMaximize]
  Caption = 'y'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 481
    Height = 281
    Caption = 'R'#233'glages des options du Chat'
    TabOrder = 0
    object BitBtn1: TBitBtn
      Left = 168
      Top = 252
      Width = 137
      Height = 25
      Caption = '&Confirmer les choix'
      TabOrder = 0
      OnClick = BitBtn1Click
      Kind = bkYes
    end
    object RadioGroupSons: TRadioGroup
      Left = 16
      Top = 24
      Width = 449
      Height = 65
      Caption = 'Lors des arriv'#233'es de messages '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemIndex = 0
      Items.Strings = (
        
          'Pas d'#39'avertissement sonore quand un message est ecrit par un uti' +
          'lisateur.'
        
          'Avertissement sonore quand un message est ecrit par un utilisate' +
          'ur.')
      ParentFont = False
      TabOrder = 1
    end
    object RadioGroupVisible: TRadioGroup
      Left = 16
      Top = 104
      Width = 449
      Height = 65
      Caption = 'Affichage '
      ItemIndex = 1
      Items.Strings = (
        'Rendre visible le Chat lors de l'#39'arriv'#233'e d'#39'un nouveau message.'
        
          'Ne pas mettre le Chat en premier plan lors de l'#39'arriv'#233'e d'#39'un nou' +
          'veau message.')
      TabOrder = 2
    end
    object GroupBoxCouleur: TGroupBox
      Left = 16
      Top = 184
      Width = 449
      Height = 49
      Caption = 'Choissir la couleur du Chat '
      TabOrder = 3
      object Panel1: TPanel
        Left = 200
        Top = 16
        Width = 81
        Height = 25
        Caption = 'Couleur'
        TabOrder = 0
        OnClick = Panel1Click
      end
      object StaticText1: TStaticText
        Left = 16
        Top = 24
        Width = 181
        Height = 17
        Caption = 'Choisissez la couleur de l'#39'application :'
        TabOrder = 1
      end
      object Button1: TButton
        Left = 328
        Top = 16
        Width = 113
        Height = 25
        Caption = 'Remettre par d'#233'faut'
        TabOrder = 2
        OnClick = Button1Click
      end
      object StaticText2: TStaticText
        Left = 296
        Top = 24
        Width = 20
        Height = 17
        Caption = 'OU'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
    end
  end
  object ColorDialog1: TColorDialog
    Ctl3D = True
    Left = 416
    Top = 8
  end
end
