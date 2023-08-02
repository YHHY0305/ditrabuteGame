import {hero,enemy,hullet} from "../object/hero"
import promptAction from '@ohos.promptAction'
import {g_object,activeapp,get_device,Slider_contro,Gauge_show,link_device,activeButon}from "../pages/founction"
let imgName = ['background.png', 'game_pause_nor.png', 'm1.png', 'start.png',
  // 敌机1
  ['enemy1.png', 'enemy1_down1.png', 'enemy1_down2.png', 'enemy1_down3.png', 'enemy1_down4.png'],
  // 敌机2
  ['enemy12.png', 'enemy12_down1.png', 'enemy12_down2.png', 'enemy12_down3.png', 'enemy12_down4.png'],
  // 敌机3
  ['enemy13_n1.png', 'enemy13_n2.png', 'enemy13_hit.png', 'enemy13_down1.png', 'enemy13_down2.png', 'enemy13_down3.png', 'enemy13_down4.png', 'enemy13_down5.png', 'enemy13_down6.png', ],
  // 游戏loading图
  ['game_loading1.png', 'game_loading2.png', 'game_loading3.png', 'game_loading4.png'],
  // 玩家飞机图
  ['hero1.png', 'hero2.png', 'hero_blowup_n1.png', 'hero_blowup_n2.png', 'hero_blowup_n3.png', 'hero_blowup_n4.png'],

  ['icon_000.png']
];
let curPhase = 2;
const TAG = "lxlx"
const PHASE_DOWNLOAD = 1;
const PHASE_READY = 2;
const PHASE_LOADING = 3;
const PHASE_PLAY = 4;
const PHASE_PAUSE = 5;
const PHASE_GAMEOVER = 6;
const csreen_width = 800;
const csreen_height = 400;

let index = 0
let hullet1:Array<hullet> =[]
let enemy1:Array<enemy> =[]
let hero1 = new hero
let settings:RenderingContextSettings = new RenderingContextSettings(true)
let context: CanvasRenderingContext2D = new CanvasRenderingContext2D(settings)
let offContext:OffscreenCanvasRenderingContext2D= new OffscreenCanvasRenderingContext2D(csreen_width, csreen_height, settings)
let score = 0
let count:number = 9
let hCout:number = 0
// 设置随机数种子
let seed = 123; // 可以用任意数字来作为种子

function seededRandom(seed, min, max) {
  let x = Math.sin(seed) * 10000;
  const result = min + (x - Math.floor(x)) * (max - min);
  return Math.floor(result);
}

function  nIgm(scr)
{
  let img = new ImageBitmap("/tracom/"+scr)
  return img
}

function  distr_link()
{
  offContext.drawImage(nIgm('icon_000.png'),0,0)
}

function gameloading()
{
    index % 1 == 0 &&   offContext.drawImage(nIgm(imgName[7][index]),800-400,80)
    index +=0.25
    if(index > 3){
      curPhase = PHASE_PLAY;
      index = 0
  }
}

function  paintLogo()
{
  offContext.drawImage(nIgm(imgName[3]),0,0,csreen_width,csreen_height,0,0,csreen_width,csreen_height)
}

function  drawGameOver()
{
  promptAction.showToast({
    message: '游戏结束\n得分：'+ score,
    duration: 2000
  });
  curPhase = PHASE_READY
  hero1.life = 6
  score = 0
  hero1.index = 0
  hullet1 = []
  enemy1 = []
  if(globalThis.remote == 1)
  {
    globalThis.remoteObject.hero = hero1
    globalThis.remoteObject.status = PHASE_READY
  }else
  {
    g_object.hero = hero1
    g_object.status = PHASE_READY
  }
  seed = 123
}

function  drawPause()
{
  offContext.drawImage(nIgm(imgName[1]),0,0)
}

function  drawhero()
{
  let i = 0
  if(hero1.life > 0){
    offContext.drawImage(nIgm(imgName[8][hero1.index]),hero1.x,hero1.y)
    count++
    if(count % 3 == 0)
    {
      hullet1.push(new hullet(hero1.x,hero1.y,1))
      hullet1.push(new hullet(hero1.x,hero1.y,2))
      hullet1.push(new hullet(hero1.x,hero1.y,3))
      count= 0
    }
    hCout++
    if(hCout %5 == 0) {
      enemy1.push(new enemy(seededRandom(seed++,20,340)))
    }
  }else{
    curPhase = PHASE_GAMEOVER
    return
  }
  for(i = 0;i < enemy1.length ; i++)
  {
      let e = enemy1[i]
      if(e.x+e.width >= hero1.x && hero1.x + hero1.width >= e.x  && e.y+e.height >= hero1.y && hero1.y+hero1.height >= e.y)
      {

        e.life-=1
        enemy1[i].index+=1
        hero1.index += 1
        hero1.life -= 1
        if(hero1.life < 0)
        {
          hero1.life = 0
        }
        if(e.life < 0)
        {
          e.life = 0
        }
        if(enemy1[i].index == 4 )
        {
          enemy1[i].index ==0
        }
        if(hero1.index == 4 )
        {
          hero1.index =0
        }
      }
    }

}

function  drawenemy1()
{
  let i = 0
  let j = 0
  for(i;i < enemy1.length;i++)
  {
    enemy1[i].x+=6

    if(enemy1[i].x < 0 || enemy1[i].x > 800 || enemy1[i].y < 0 || enemy1[i].y > 480)
    {
      enemy1[i].life = 0
    }
    if(enemy1[i].life == 0)
    {
      score += 1
      enemy1.splice(i,1)
    }
  }
  for(i = 0 ;i < enemy1.length;i++)
  {
    offContext.drawImage(nIgm(imgName[4][enemy1[i].index]),enemy1[i].x,enemy1[i].y)
  }
  for(i = 0;i < enemy1.length ; i++)
  {
    for(j = 0; j < hullet1.length; j++)
    {
      let h = hullet1[j]
      let e = enemy1[i]
      if(e.x+e.width >= h.x && h.x + h.width >= e.x  && e.y+e.height >= h.y && h.y+h.height >= e.y)
      {
        e.life-=1
        enemy1[i].index+=1
        if(e.life < 0)
        {
          e.life = 0
        }
        if(enemy1[i].index == 4 )
        {
          enemy1[i].index ==0
        }
      }
    }
  }
}

function  drawhullet1()
{
  let i = 0
  for(i;i < hullet1.length;i++)
  {
    switch(hullet1[i].n){
      case 1:
        hullet1[i].y-=1
        hullet1[i].x-=40
        break
      case 2:
        hullet1[i].y+=1
        hullet1[i].x-=40
        break
      case 3:
        hullet1[i].x-=40
        break
      default:
        console.log("lxlx invalid n")
        break
    }
    if(hullet1[i].x < 0 || hullet1[i].x >= 800 || hullet1[i].y < 0 || hullet1[i].y >= 480)
    {
      hullet1[i].removable = 1
    }
    if(hullet1[i].removable == 1)
    {
      hullet1.splice(i,1)
    }
  }
  for(i = 0 ;i < hullet1.length;i++)
  {
    offContext.drawImage(nIgm(imgName[2]),hullet1[i].x,hullet1[i].y)
  }
}

function  drawsocre()
{
  offContext.strokeText('分数：'+score,350, 20)
}

export function ControlHero(x:number,y:number)
{
  hero1.x = x
  hero1.y = y
}

@Component
export struct PlaneGame {
  @State score:number = 0
  @State select: number = 2
  @State x:number = 676
  @State y:number = 142

  private device: string[] = ['本机器']
  private declareid: string[] = ['mydevice']
  build() {
    Column() {
      Stack({alignContent: Alignment.Start}){
        Canvas(context)
          .backgroundImage('/tracom/background.png')
          .onReady(()=>{
            console.info(TAG+ "页面刷新")
            setInterval(()=>{
              if(globalThis.remote == 1&& curPhase == 2){
                offContext.clearRect(0,0,csreen_width-5,csreen_height-5)
                curPhase =globalThis.remoteObject.status
              }else if(curPhase == 2){
                offContext.clearRect(0,0,csreen_width-5,csreen_height-5)
                curPhase = g_object.status
              }
              switch (curPhase){
                case PHASE_READY:
                  offContext.clearRect(0,0,csreen_width-5,csreen_height-5)
                  paintLogo()
                  distr_link()
                  break
                case PHASE_LOADING:
                  gameloading()
                  break
                case PHASE_PLAY:
                  if(globalThis.remote == 1)
                  {
                    console.info(TAG+globalThis.remote+"读取了")
                    hero1 = globalThis.remoteObject.hero
                  } else
                  {
                    hero1 = g_object.hero
                  }
                  offContext.clearRect(0,0,csreen_width-1,csreen_height-1)
                  drawsocre()
                  drawenemy1()
                  drawhullet1()
                  drawhero()
                  break
                case PHASE_PAUSE:
                  drawPause()
                  break
                case PHASE_GAMEOVER:
                  drawGameOver()
                  break
              }
              let image = offContext.transferToImageBitmap();
              context.transferFromImageBitmap(image);

              this.score = score
            },100)
          })
          .onTouch((event) => {
            if( curPhase == PHASE_PLAY)
            {
              console.info(TAG+hero1.x +"  "+hero1.y)
              console.info(TAG+event.touches[0].x +"  "+event.touches[0].y)
              if(event.touches[0].x>hero1.x && event.touches[0].x <hero1.x+150 && event.touches[0].y>hero1.y && event.touches[0].y-20 <hero1.y+70)
              {
                hero1.x=event.touches[0].x-124
                hero1.y=event.touches[0].y-50
              }
              if( globalThis.remote == 1)
              {
                globalThis.remoteObject.hero = hero1
              }else
              {
                g_object.hero = hero1
              }
            }
          })
          .onClick((event)=>{
            if(curPhase == 2 && event.x > 96 && event.y > 96 )
            {
              offContext.clearRect(0,0,csreen_width-1,csreen_height-1)
              if(  globalThis.remote == 1)
              {
                globalThis.remoteObject.status = PHASE_LOADING
              }else{
                g_object.status = PHASE_LOADING
              }
              curPhase = PHASE_LOADING
            }
            if(event.x < 96 && event.y < 96 && curPhase == 2)
            {
              let deviceList =get_device()

              if(deviceList != null)
              {
                this.device.push(deviceList[0].deviceName)
              }
              TextPickerDialog.show({
                range: this.device,
                selected: this.select,
                onAccept: (value: TextPickerResult) => {
                  if(deviceList != null)
                  { let Coordinate
                    Coordinate = activeapp(deviceList[0].deviceId)
                    this.x = Coordinate[0]
                    this.y = Coordinate[1]
                  }
                  // 设置select为按下确定按钮时候的选中项index，这样当弹窗再次弹出时显示选中的是上一次确定的选项
                  this.select = value.index
                  console.info("TextPickerDialog:onAccept()" + JSON.stringify(value))
                },
                onCancel: () => {
                  console.info("TextPickerDialog:onCancel()")
                },
                onChange: (value: TextPickerResult) => {
                  console.info("TextPickerDialog:onChange()" + JSON.stringify(value))
                }
              })
              this.device = ["本机器"]
            }
          })
      }
    }
  }
}