<?  
$token = "";//请求头（没有不填）
$url = "0.0.0.0:5700";//请求的url

$data = file_get_contents("php://input");
if($data == null)
	exit;

$data = json_decode($data, true);

if($data['self_id'] == $data['user_id'])
	return;

Notify($data['message_type'] == "group" ? $data['user_id'] : $data['user_id'], $data['message'], $data['message_type'] == "group" ? false : true, $token, $url);

/*发送函数Noify
	$qqnum qq号
	$text 内容
	$IsUserMessage （true为私聊，false 群消息）
	$token //请求头（没有不填）
	$url //请求的url
*/
	
function Notify($qqnum, $text, $IsUserMessage, $token, $url)
{
	$post_data = $IsUserMessage? 
	array(
	'message' => $text,
	'user_id'=> $qqnum
	):
	array(
	'message' => $text,
	'group_id'=> $qqnum
	);
	
	$postdata = http_build_query($post_data);
	$options = array(
		'http' => array(
		'method' => 'POST',
		'header' => 'Authorization: Bearer '.$token,
		'content' => $postdata,
		'timeout' => 15 * 60 // 超时时间（单位:s）
		)
	);
	
	$context = stream_context_create($options);
	$result = file_get_contents($url."/send_msg?", false, $context);
}