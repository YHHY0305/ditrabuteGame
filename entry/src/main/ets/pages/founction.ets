import lxpwmapi from '@ohos.lxpwmapi'
import distributedObject from '@ohos.data.distributedDataObject';
import deviceManager from '@ohos.distributedHardware.deviceManager';
import {hero} from '../object/hero'
let context
export let g_object
let deviceList1:deviceManager.DeviceInfo[]
context = getContext(this) as any
let hero1 = new hero
g_object = distributedObject.create(context, {name:"game",status:2,hero:hero1});

@Component
export struct Gauge_show {
  @Link value: number;
  build(){
    Gauge({ value: this.value,min:500000,max:2500000 })
      .width(50).height(50)
      .colors([[0x317AF7, 1], [0x5BA854, 1], [0xE08C3A, 1], [0x9C554B, 1]])
  }
}

@Component
export struct Slider_contro {
  @Link value:number;
  build(){
    Slider({
      value: this.value,
      min: 500000,
      max: 2500000,
      style: SliderStyle.OutSet
    })
      .showTips(true)
      .onChange((value: number, mode: SliderChangeMode) => {
        g_object.duty = value
        this.value = value
        lxpwmapi.Napi_HDF_control(0,g_object.duty)
        console.info('value:' + value + 'mode:' + mode.toString())
      })
  }
}

@Component
export struct activeButon{
  build(){
    Button('拉起应用')

      .onClick(()=>{
        deviceManager.createDeviceManager('com.example.mydevice', (err, value) => {
          if (!err) {
            let devManager = value;
            let deviceList = devManager.getTrustedDeviceListSync();
            console.info('lxlx'+JSON.stringify(deviceList))
            console.info('lxlx'+JSON.stringify(deviceList[0].deviceName))
            let want = {
              deviceId: deviceList[0].deviceId,
              bundleName: 'com.example.mydevice',
              abilityName: 'EntryAbility'
            };
            context.startAbility(want, (error) => {
              if (error.code) {
                // 处理业务逻辑错误
                console.info('lxlx startAbility failed, error.code: ' + JSON.stringify(error.code) +
                ' error.message: ' + JSON.stringify(error.message));
                return;
              }
              console.info('lxlx startAbility succeed');
            });
          }
        })
      })

  }
}

@Component
export struct link_device{
  @Link value:number
  @Link x:number
  @Link y:number
  @State temp:number = 0
  private changeCallback(sessionId, changeData) {
    console.info(`change: ${sessionId}`);
    if (changeData !== null && changeData !== undefined) {
      changeData.forEach(element => {
        this.x = g_object.x
        this.y = g_object.y
        console.info(`lxlx The element ${g_object[element]} changed.`);
      });
    }
  }

  build(){
    Button('连接设备')
      .onClick(()=>{
          let sessionId = '123456';
          g_object.setSessionId(sessionId);
          g_object.setSessionId(distributedObject.genSessionId(), ()=>{
            console.info("lxlx join session");
          });
          console.info(`lxlx name:${g_object['x']}`);
          g_object.on("change", this.changeCallback.bind(this));
          this.temp = 1
      })
  }
}

export function get_device():deviceManager.DeviceInfo[]
{
deviceManager.createDeviceManager('com.example.mydevice', (err, value) => {
    if (!err) {
      let devManager = value;
      let deviceList = devManager.getTrustedDeviceListSync();
      console.info('lxlx'+JSON.stringify(deviceList))
      console.info('lxlx'+JSON.stringify(deviceList[0].deviceName))
      deviceList1 =deviceList
    }
  })
  return deviceList1
}

export function  activeapp(dviceid:String):Array<number>
{
  let  x
  let  y
  let  Coordinate  = []
  g_object.x = 1
   function  changeCallback(sessionId, changeData) {
    console.info(`change: ${sessionId}`);
    if (changeData !== null && changeData !== undefined) {
      changeData.forEach(element => {
        console.info(`lxlx The element ${g_object[element]} changed.`);
      });
    }
  }
  let want = {
    deviceId: dviceid,
    bundleName: 'com.example.mydevice',
    abilityName: 'EntryAbility',
    parameters: {
      info: 1
    }
  };
  context.startAbility(want, (error) => {
    if (error.code) {
      // 处理业务逻辑错误
      console.info('lxlx startAbility failed, error.code: ' + JSON.stringify(error.code) +
      ' error.message: ' + JSON.stringify(error.message));
      return;
    }
    console.info('lxlx startAbility succeed');
  });
  let sessionId = '123456';
  g_object.setSessionId(sessionId);
  g_object.on("change", changeCallback.bind(this));
  return Coordinate

}




