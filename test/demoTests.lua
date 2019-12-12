function regionCheckTest()  
  RED_COLOR_ANSI = "\x1B[31m"
  GREEN_COLOR_ANSI = "\x1b[32m"
  RESET_COLOR_ANSI = "\x1b[39m"
  TEST_ID = "[regionCheckTest] "
  SUCCESS = "Success"
  FAIL = RED_COLOR_ANSI .. "Failed"
  
  emuRegion = emu.getState().region
  progRegion = emu.read(0, emu.memType.cpuDebug, false)
  
  if emuRegion == progRegion then
    print(TEST_ID .. SUCCESS)
  else
    print(TEST_ID .. FAIL)
  end
 
  emu.stop(0)
end

emu.addEventCallback(regionCheckTest, emu.eventType.endFrame)
--emu.addMemoryCallback(regionCheckTest, emu.memCallbackType.cpuWrite, 0)

