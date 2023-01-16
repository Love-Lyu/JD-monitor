zqdyjtx(){
local cookie=$1
local zqdyjtx=`curl -s -H "referer:https://wqs.jd.com/" -H "cookie:$cookie" "https://wq.jd.com/prmt_exchange/client/exchange?appCode=ms2362fc9e&bizCode=makemoneyshop&$2"`
if [ `echo "$zqdyjtx" | grep -o "{" | wc -l` -ge 1 ]
then local msg=`echo "$zqdyjtx" | jq | grep -o "msg.*" | cut -d '"' -f3`
else local msg=`echo "$zqdyjtx" | grep -o "title.*" | cut -d "<" -f1 | cut -d ">" -f2`
fi
[ -n "$msg" ] && echo 第$c个账号第$i次抢兑$msg
}

run(){
for ((i=1;i<=30;i++))
do
zqdyjtx "$1" "$2" &
sleep 0
done
}

if [ -f zqdyjck ]
then cklist=`cat zqdyjck`
if [ -n "$cklist" ]
then ckzs=`echo "$cklist" | wc -l`
checkkh=`echo "$cklist" | sort -u | wc -l`
if [ $ckzs -eq $checkkh ]
then checkck=`echo "$cklist" | grep -o "=" | wc -l`
checkid=`echo "$cklist" | grep -o "@" | wc -l`
if [ $checkck -eq $((ckzs*3)) -a $checkid -eq $ckzs ]
then st=`date +%s%3N`
for ((c=1;c<=ckzs;c++))
do
ck=`echo "$cklist" | sed -n "$c"p | cut -d "@" -f1`
ruleId=`echo "$cklist" | sed -n "$c"p | cut -d "@" -f2`
run "$ck" "$ruleId"
wait
et=`date +%s%3N`
echo 耗时$((et-st))
done
else echo "zqdyjck文件内容格式不对，请检查。标准格式为：pt_pin=xxx;pt_key=xxx@ruleId=xxx，注意ruleId中i为大写，文件内不能有空行。"
fi
else echo "zqdyjck文件内容格式不对，请删除空行。"
fi
else echo "zqdyjck文件无内容。请按标准格式保存至zqdyjck文件，多账户一行一个。标准格式为：pt_pin=xxx;pt_key=xxx@ruleId=xxx，注意ruleId中i为大写，文件内不能有空行。"
fi
else echo "脚本目录下不存在zqdyjck文件，请按标准格式保存至zqdyjck文件，多账户一行一个。标准格式为：pt_pin=xxx;pt_key=xxx@ruleId=xxx，注意ruleId中i为大写，文件内不能有空行。"
fi