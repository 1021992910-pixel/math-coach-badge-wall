param(
  [string]$QrPath = 'C:\Users\10219\Documents\Codex\2026-11-02\ck\outputs\数学讲题陪练_首版资料包\数学讲题陪练_独立徽章墙二维码.png',
  [string]$OutputPath = 'C:\Users\10219\Documents\Codex\2026-11-02\ck\outputs\数学讲题陪练_首版资料包\数学讲题陪练（三年级上）_首次使用5步.png'
)

Add-Type -AssemblyName System.Drawing

$titleFontPath = 'E:\AI青少年课程\Codex\02_Codex自用资料库\04_图片与海报制作标准\可商用字体库\01_艺术标题\寒蝉全圆体_ChillRoundF\ChillRoundF-v3.0.ttf'
$bodyFontPath = 'E:\AI青少年课程\Codex\02_Codex自用资料库\04_图片与海报制作标准\可商用字体库\02_温暖副标题\霞鹜文楷_LXGWWenKai\LXGWWenKai-Medium-v1.522.ttf'

function New-RoundedPath([float]$x,[float]$y,[float]$w,[float]$h,[float]$r) {
  $path = [System.Drawing.Drawing2D.GraphicsPath]::new()
  $d = $r * 2
  $path.AddArc($x,$y,$d,$d,180,90)
  $path.AddArc($x+$w-$d,$y,$d,$d,270,90)
  $path.AddArc($x+$w-$d,$y+$h-$d,$d,$d,0,90)
  $path.AddArc($x,$y+$h-$d,$d,$d,90,90)
  $path.CloseFigure()
  return $path
}

function Draw-CenteredText($g,[string]$text,$font,$brush,[float]$centerX,[float]$y) {
  $size = $g.MeasureString($text,$font)
  $g.DrawString($text,$font,$brush,$centerX-($size.Width/2),$y)
}

function Draw-Step($g,[int]$number,[string]$title,[string]$line1,[string]$line2,[float]$y,$fonts,$brushes) {
  $box = New-RoundedPath 85 $y 910 154 24
  $g.FillPath($brushes.Box,$box)
  $g.DrawEllipse($brushes.Coral,112,$y+43,68,68)
  $nSize = $g.MeasureString([string]$number,$fonts.Number)
  $g.DrawString([string]$number,$fonts.Number,$brushes.White,146-($nSize.Width/2),$y+51)
  $g.DrawString($title,$fonts.StepTitle,$brushes.Ink,210,$y+26)
  $g.DrawString($line1,$fonts.Body,$brushes.Muted,210,$y+73)
  if ($line2) { $g.DrawString($line2,$fonts.Body,$brushes.Muted,210,$y+108) }
  $box.Dispose()
}

$fontCollection = [System.Drawing.Text.PrivateFontCollection]::new()
$fontCollection.AddFontFile($titleFontPath)
$fontCollection.AddFontFile($bodyFontPath)
$titleFamily = $fontCollection.Families | Where-Object Name -eq '寒蝉全圆体' | Select-Object -First 1
$bodyFamily = $fontCollection.Families | Where-Object Name -eq '霞鹜文楷 Medium' | Select-Object -First 1

$fonts = [pscustomobject]@{
  Title = [System.Drawing.Font]::new($titleFamily,58,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Pixel)
  Subtitle = [System.Drawing.Font]::new($bodyFamily,30,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Pixel)
  Slogan = [System.Drawing.Font]::new($titleFamily,30,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Pixel)
  Number = [System.Drawing.Font]::new($titleFamily,35,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Pixel)
  StepTitle = [System.Drawing.Font]::new($titleFamily,31,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Pixel)
  Body = [System.Drawing.Font]::new($bodyFamily,25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Pixel)
  Note = [System.Drawing.Font]::new($bodyFamily,23,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Pixel)
}

$brushes = [pscustomobject]@{
  White = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::White)
  Header = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#216B62'))
  Ink = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#173B52'))
  Muted = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#667C8B'))
  Coral = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#EF7154'))
  Box = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#FFFDF8'))
  Pale = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#EEF8F6'))
  Safety = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#FFF3E8'))
}

$bitmap = [System.Drawing.Bitmap]::new(1080,1600,[System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($bitmap)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$g.Clear([System.Drawing.ColorTranslator]::FromHtml('#F3F7FB'))

$header = New-RoundedPath 40 40 1000 290 42
$g.FillPath($brushes.Header,$header)
Draw-CenteredText $g '数学讲题陪练（三年级上）' $fonts.Title $brushes.White 540 85
Draw-CenteredText $g '首次使用说明｜家长请看' $fonts.Subtitle $brushes.White 540 175
Draw-CenteredText $g '讲得清，才是真的学会' $fonts.Slogan $brushes.White 540 235

Draw-Step $g 1 '微信扫码' '扫描“数学讲题陪练（三年级上）”' '公益学习入口二维码。' 365 $fonts $brushes
Draw-Step $g 2 '继续访问' '出现提示时，依次点击' '“继续访问”“去访问”。' 535 $fonts $brushes
Draw-Step $g 3 '开始讲题' '进入页面后，点击' '“开始今天的讲题”。' 705 $fonts $brushes
Draw-Step $g 4 '点击右上角“…”' '打开扣子后，不点底部“注册”；' '点击右上角的三个点。' 875 $fonts $brushes
Draw-Step $g 5 '在浏览器中打开' '选择“在浏览器中打开”，填写手机号' '和验证码，完成首次登录即可使用。' 1045 $fonts $brushes

$noteBox = New-RoundedPath 85 1230 610 270 24
$g.FillPath($brushes.Pale,$noteBox)
$g.DrawString('以后怎么用？',$fonts.StepTitle,$brushes.Ink,118,1260)
$g.DrawString('收藏二维码或网页，后续通常直接扫码即可；',$fonts.Body,$brushes.Muted,118,1312)
$g.DrawString('如果登录失效，再重新验证一次。',$fonts.Body,$brushes.Muted,118,1348)
$safeBox = New-RoundedPath 112 1402 555 67 16
$g.FillPath($brushes.Safety,$safeBox)
$g.DrawString('验证码只在扣子官方登录页填写。',$fonts.Note,$brushes.Coral,135,1420)

$qr = [System.Drawing.Image]::FromFile($QrPath)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
$g.FillRectangle($brushes.White,733,1252,250,250)
$g.DrawImage($qr,[System.Drawing.Rectangle]::new(745,1264,226,226))

$outDir = Split-Path -Parent $OutputPath
if (-not (Test-Path -LiteralPath $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }
$bitmap.Save($OutputPath,[System.Drawing.Imaging.ImageFormat]::Png)

$qr.Dispose(); $header.Dispose(); $noteBox.Dispose(); $safeBox.Dispose()
$fonts.psobject.Properties.Value | ForEach-Object { $_.Dispose() }
$brushes.psobject.Properties.Value | ForEach-Object { $_.Dispose() }
$g.Dispose(); $bitmap.Dispose(); $fontCollection.Dispose()
Write-Output $OutputPath
