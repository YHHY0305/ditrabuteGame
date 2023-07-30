import {hero,enemy,hullet} from "../object/hero"
import promptAction from '@ohos.promptAction'
import {g_object,activeapp,get_device,push_xy,Slider_contro,Gauge_show,link_device,activeButon}from "../pages/founction"
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

}

function  drawPause()
{
  offContext.drawImage(nIgm(imgName[1]),0,0)
}

function  drawhero()
{
  if(hero1.life > 0){
    switch(hero1.life){
      case 3:
        offContext.drawImage(nIgm(imgName[8][0]),hero1.x,hero1.y)
        break
      case 2:
        offContext.drawImage(nIgm(imgName[8][1]),hero1.x,hero1.y)
        break
      case 1:
        offContext.drawImage(nIgm(imgName[8][2]),hero1.x,hero1.y)
        break
    }
    hero1.count++
    if(hero1.count % 3 == 0)
    {
      hullet1.push(new hullet(hero1.x,hero1.y,1))
      hullet1.push(new hullet(hero1.x,hero1.y,2))
      hullet1.push(new hullet(hero1.x,hero1.y,3))
      hero1.count = 0
    }
    hero1.hCout++
    if(hero1.hCout %5 == 0) {
      enemy1.push(new enemy(Math.round(Math.random() * 320 + 20)))
    }
  }else{
    curPhase = PHASE_GAMEOVER
    return
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
        h.removable = 1
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

export function ControlHero(x:number,y:number)
{
  hero1.x = x
  hero1.y = y
}

@Component
export struct PlaneGame {
  @State select: number = 2
  @Link x:number
  @Link y:number
  private device: string[] = ['本机器']
  private declareid: string[] = ['mydevice']
  build() {
    Column() {
      Canvas(context)
        .backgroundImage('/tracom/background.png')
        .onReady(()=>{

          setInterval(()=>{
            if(globalThis.remote == 1 && curPhase == 2)
            {
              offContext.clearRect(0,0,csreen_width-1,csreen_height-1)
              console.info("lxlx 状态有变化"+globalThis.status)
              curPhase =globalThis.status
            }
            switch (curPhase){
              case PHASE_READY:
                paintLogo()
                distr_link()
                break
              case PHASE_LOADING:
                gameloading()
                break
              case PHASE_PLAY:
                hero1.x = this.x
                hero1.y = this.y
                if(globalThis.remote == 1)
                {
                  hero1.x =globalThis.x
                  hero1.y =globalThis.y
                }
                offContext.clearRect(0,0,csreen_width-1,csreen_height-1)
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
          },100)
        })
        .onTouch((event) => {
          this.x=event.touches[0].x-124
          this.y=event.touches[0].y-50
          push_xy(event.touches[0].x-124,event.touches[0].y-50)
        })
        .onClick((event)=>{
          if(curPhase == 2 && event.x > 96 && event.y > 96 )
          {
            offContext.clearRect(0,0,csreen_width-1,csreen_height-1)
            g_object.status = PHASE_LOADING

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