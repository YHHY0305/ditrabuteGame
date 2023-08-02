import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import distributedDataObject from '@ohos.data.distributedDataObject';

export default class EntryAbility extends UIAbility {
  onCreate(want, launchParam) {

    let sessionId = '123456';
    let funcAbilityWant = want;
    console.info("lxlx test")
    console.info("lxlx   want参数"+ JSON.stringify(funcAbilityWant.parameters))
    console.info("lxlx   want参数"+ funcAbilityWant.parameters.info)
    if(funcAbilityWant.parameters.info == 1)
    {
      console.info("lxlx jinlai;")
      //join
        globalThis.remoteObject = distributedDataObject.create(this.context, {
        name:undefined,
        status:2,
          hero:undefined,
      })

      console.info("lxlx  daozhelil")

      globalThis.remoteObject.setSessionId(sessionId).then(()=>{
          console.info("lxlx join session.");
          console.info("lxlx"+globalThis.remoteObject.name)
        }).catch((erro)=>{
          console.info("lxlx加入错误"+erro.code+erro.message)
        })
      //subscrib
      function changeCallback(sessionId, changeData) {
        console.info("lxlx"+JSON.stringify(globalThis.remoteObject.hero))
        console.info(`change: ${sessionId}`);
        if (changeData !== null && changeData !== undefined) {
          globalThis.remote = 1
          globalThis.app = 1
          changeData.forEach(element => {
          });
        }
      }
      globalThis.remoteObject.on("change", changeCallback.bind(this));
    }
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
