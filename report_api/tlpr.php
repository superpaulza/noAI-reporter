<?php
 
$file = tmpfile();
$path = stream_get_meta_data($file)['uri'];

$image = $_POST['image'];

$curl = curl_init();

// $percent = 0.8;

// $img_data = base64_decode($image);
// $im = imagecreatefromstring($img_data);
// $width = imagesx($im);
// $height = imagesy($im);
// $newwidth = $width * $percent;
// $newheight = $height * $percent;

// $thumb = imagecreatetruecolor($newwidth, $newheight);
// $img_data = base64_decode(imagejpeg($thumb, NULL, 75));

$img = base64_decode($image);
file_put_contents("$path", $img);


$data = array("file" => new CURLFile($path, mime_content_type($path), basename($path)));
 
curl_setopt_array($curl, array(
  CURLOPT_URL => "https://api.aiforthai.in.th/panyapradit-lpr",
  CURLOPT_RETURNTRANSFER => true,
  CURLOPT_ENCODING => "",
  CURLOPT_MAXREDIRS => 10,
  CURLOPT_TIMEOUT => 30,
  CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
  CURLOPT_CUSTOMREQUEST => "POST",
  CURLOPT_POSTFIELDS => $data,
  CURLOPT_HTTPHEADER => array(
    "Content-Type: multipart/form-data",
    "apikey: 2LxMevxHYrLMMxuMB6aRmJSbCafW7Bde"
  )
));
 
$response = curl_exec($curl);
$err = curl_error($curl);

curl_close($curl);
 
if ($err) {
  echo "cURL Error #:" . $err;
} else {
  echo $response;
}
?>