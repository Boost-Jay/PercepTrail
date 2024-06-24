
> **[點擊此處查看 PDF](User_Interface.pdf)**

## 創新 app 競賽 開發

## 初始化流程：收集個人資訊（暫不）
暱稱 *1、出生日期 *1、性別 *1、身高 *1、體重 *1、是否有慢性病 *1、是否有定期服用的藥物 *1、平常一週的活動水平 *1、長期居住地點 *1
同意隱私權收集。*1

親愛的用戶：
為了提供您個性化的服務和改善您的使用體驗，我們的應用程式【App名稱】在您的同意下將收集並使用您的個人資料。我們承諾將嚴格遵守個人資料保護法規，確保您的資料安全。
我們將收集的資料包括：
* 基本資訊：姓名、出生日期、性別、聯絡方式。
* 健康狀況：病史、慢性病狀態、藥物使用情況。
* 生活習慣與興趣：您的興趣愛好和常居地區。
* 科技使用能力：您對科技產品的熟悉度。
資料使用目的：
* 提供個性化的健康和活動建議。
* 優化我們的應用功能和用戶介面。
* 進行統計分析以改善應用服務。
您的權利：
* 查詢或請求閱覽您的個人資料。
* 請求製作複製品。
* 請求補充或更正。
* 請求停止收集、處理或利用您的個人資料。
* 請求刪除您的個人資料。
我們將不會將您的個人資料用於本同意書未提及的其他用途，亦不會未經您同意而對外公開或分享。


## 快問快答
頁面1：
點擊 button 後，中間轉盤會隨機選中一個數字，然後跳頁傳值

頁面2：
顯示上一頁傳來的數值，最多3分鐘，假設1分鐘最多可以完成7張

頁面3：
根據前一個頁面傳來的數值，放置到進度條上，每過30秒提醒使用者一次。
- 0.5：加油！ 
- 1：再接再厲！
- 1.5：堅持下去！
- 2：剩下最後了！
- 2.5：進入最後階段

計時器會一直跑，中間圖片和文字會隨著button 觸發做更換，並且判斷使否跟預設選項一樣，進行分數累加。
> 答對＋100 ; 答錯 - 50 。
> 保底分數是20

頁面4：
顯示本次挑戰獲得的積分
並且進度環的最高分是從上一次的紀錄來去做％數比對

## 拍照頁面
離開：返回主頁面
保存：存到手機相簿與本地資料庫

## 項目1 : 識別
進度條是以累積的形式呈現，最多給3分鐘。
每45秒提醒使用者。
分書區隔：
45:+1000
90:700
135:500
180:300
每錯一次：-70
保底分數20
積分環的用例同“SummaryViewController”
選出照片相符的部分：
1. 請GPT把圖片以九宮格的方式劃分，並請他隨機出題目，去辨別哪些是合適的項目，並回傳為答案的編號。

2. 手動把圖片切割成9份，請GPT根據不同圖片來判斷可以怎麼出題目並回傳為答案的編號。

如果錯誤會跳出toast再試一次。

## 項目2 : 拼圖

## 項目3 : 配對
須先收集3張圖片才能開放
3張圖片不能有重複項目
3張圖片個重複兩次，看能不能合閉在打開
計分方式同“識別”

## 項目4 : 地點探訪🌟
設定活動的地點（預想比賽當天是設在台大校園周遭，簡報的話則設在附近就行）
藍色星星表示使用者當前選取的狀態
上面的進度環只要採計時間跟步數就行了，從使用者初始化設定來抓他的一圈圓週期
可能過1分鐘就會提醒使用者記得拍照，按下拍照時會跳到“TakePhoneViewController” 然後離開或保存要能再跳回當前活動進度。可以跳一個Toast來提醒成功完成拍照。
最後到達指定的地點後會再跳出一個小遊戲（上面項目1~3） 完成後會跳出結算畫面（可以參考“SummaryViewController”）
然後按下底下button 會跳回”MainTabBarController”

## 初始化選項
設定每天最多的目標值（運動時間＋目標步數）

## 額外項目
添加 ShowCase
修改主畫面的介面＋加上進度環
