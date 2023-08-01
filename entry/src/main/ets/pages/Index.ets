import {PlaneGame} from "./flygame"
let context;
context = getContext(this) as any
function requestPermission() {
  context = getContext(this) as any
  let permissions: Array<string> = ['ohos.permission.DISTRIBUTED_DATASYNC']
  context.requestPermissionsFromUser(permissions).then((data) => {
    console.info("Succeed to request permission from user with data: "+ JSON.stringify(data))
  }).catch((error) => {
    console.info("Failed to request permission from user with error: "+ JSON.stringify(error))
  })
}
@Entry
@Component
struct Index {
  @State value: number = 0
  @State x:number = 0
  @State y:number = 0
  async aboutToAppear(){
    await requestPermission()
  }
  build() {
    Row() {
      Column(){
         PlaneGame()
      }
    }
  }
}