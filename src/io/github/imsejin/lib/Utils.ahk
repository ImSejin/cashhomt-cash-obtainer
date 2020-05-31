#SingleInstance Force
#NoEnv

SetWorkingDir %A_ScriptDir%
SetBatchLines -1

/*
 * `Gdip`, `Gdip_ImageSearch` 라이브러리를 필요로 한다.
 */
class Utils
{
	/*
	 * 윈도우에서 이미지를 찾는다.
	 * 
	 * <pre>
	 * Utils.searchImage(이미지경로, 윈도우핸들, 출력변수_X좌표, 출력변수_Y좌표): 이미지를 찾았는가?
	 * </pre>
	 */
	searchImage(image, hwnd, byref vx, byref vy)
	{
		pToken := Gdip_Startup() 
		pBitmapHayStack := Gdip_BitmapFromhwnd(hwnd) 
		pBitmapNeedle := Gdip_CreateBitmapFromFile(image) 

		; 회색(#7F7F7F)을 투명색으로 인식한다
		if (Gdip_ImageSearch(pBitmapHayStack, pBitmapNeedle, list, 0, 0, 0, 0, 10, 0x7F7F7F, 1, 1))
		{  
			StringSplit, LISTArray, LIST, `,
			vx := LISTArray1 
			vy := LISTArray2
			Gdip_DisposeImage(pBitmapHayStack), Gdip_DisposeImage(pBitmapNeedle)
			Gdip_Shutdown(pToken)
			
			return true
		}
		else
		{
			Gdip_DisposeImage(pBitmapHayStack), Gdip_DisposeImage(pBitmapNeedle)
			Gdip_Shutdown(pToken)
			
			return false
		}
	}
	
	/*
	 * 윈도우를 활성화하지 않고 마우스를 클릭합니다.
	 * 
	 * <pre>
	 * Utils.clickInactively(X좌표, Y좌표)
	 * </pre>
	 */
	clickInactively(x, y, winNm)
	{
		lParam := x|y<<16
		PostMessage, 0x201, 1, %lParam%, , %winNm%
		PostMessage, 0x202, 0, %lParam%, , %winNm%
		
		return
	}
	
	/*
	 * 현재의 연월일를 반환한다.
	 *
	 * <pre>
	 * Utils.getToday(): "20200219"
	 * </pre>
	 */
	getToday()
	{
		return % A_YYYY A_MM A_DD
	}
	
	/*
	 * 현재의 연월일시분초를 반환한다.
	 *
	 * <pre>
	 * Utils.getCurrentDateTime(): "20200219141803"
	 * </pre>
	 */
	getCurrentDateTime()
	{
		return %A_Now%
	}
	
	/*
	 * 현재의 연월일시분초를 콘솔 형식으로 반환한다.
	 *
	 * <pre>
	 * Utils.getConsoleTime(): "2020-02-19 14:18:03.532"
	 * </pre>
	 */
	getConsoleTime()
	{
		; FormatTime, consoleTime, , yyyy-MM-dd HH:mm:ss
		; return consoleTime
		
		return % A_YYYY . "-" . A_MM . "-" . A_DD . " " . A_Hour . ":" . A_Min . ":" . A_Sec . "." . A_MSec
	}
	
	/*
	 * 해당 메시지를 지정한 파일에 로그를 남긴다.
	 *
	 * <pre>
	 * Utils.logger("debugging", "logger.log"): "2020-02-19 14:18:03 debugging\n"
	 * </pre>
	 */
	logger(msg, fileName)
	{
		FileAppend, % this.getConsoleTime() . " " . msg . "`n", %fileName%
		return
	}
}
