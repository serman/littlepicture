<script setup>
import p5 from 'p5'
import { nextTick, ref, onMounted, onUnmounted, watchEffect } from 'vue'
import { useElementSize } from '@vueuse/core'

const props = defineProps({
  number: {
    type: Number,
    default: 96
  },
  canvasHeight: {
    type: Number,
    default: 150
  },
  maxWaves: {
    type: Number,
    default: 10
  }
})

const canvasp5container = ref(null)
const canvasp5 = ref(null)
const { width } = useElementSize(canvasp5container)

const sketch = (s) => {
  let x = 100
  let theta = s.random(0, 2 * Math.PI)
  let thetainc = s.random(0.03, 0.1)
  let theta2 = 0
  let theta2inc = s.random(0.01, 0.04)
  let wavelength
  s.setup = () => {
    s.frameRate(40) 
    s.createCanvas(width.value, props.canvasHeight, 'P2D', canvasp5.value)
    wavelength = width.value / props.maxWaves
  }

  s.draw = () => {
    wavelength = width.value / props.maxWaves
    s.clear()
    theta += thetainc
    theta2 += theta2inc
    // lets draw a sin wave
    s.noFill()
    s.strokeWeight(1.5)
   // s.stroke(242, 201, 76, 130) 
   s.stroke('255','255','255',192)
    const numberofWaves = props.number
    const waveheight = s.height * 0.8
    const millis = s.millis()
    const wavesLength = numberofWaves * wavelength
    const wavesInitPoint = (s.width - wavesLength) / 2

    if (x < wavesInitPoint + numberofWaves * wavelength) x += 10

    //  waveheight / 2 +
    // (s.noise(i / 5, millis/100) * waveheight) / 6+

    s.beginShape()
    for (let i = 0; i < wavesInitPoint; i++) {
      s.vertex(i, waveheight / 2 + (s.noise(i, millis / 200) * waveheight) / 8)
    }
    for (let i = wavesInitPoint; i < wavesInitPoint + wavesLength; i++) {
      s.vertex(
        i,
        ( s.noise(i*100 , millis / 200) * waveheight) / 4 
          +
          waveheight / 2 + //offset to center
          (s.sin(numberofWaves * (i / wavesLength) * 2 * Math.PI + theta) * waveheight) / 2
      )
    }
    for (let i = wavesInitPoint + wavesLength; i < s.width; i++) {
      s.vertex(i, waveheight / 2 + (s.noise(i, millis / 200) * waveheight) / 8)
    }
    s.endShape()
  }
}

let p5instance = null

onUnmounted(() => {
  p5instance.remove()
  p5instance = null
})

watchEffect(() => {
  if (p5instance != null && width.value > 0 && props.canvasHeight > 0) {
    p5instance.resizeCanvas(width.value, props.canvasHeight)
  } else p5instance = new p5(sketch)
})
</script>
<template>
  <div class="w-full">
    <div class="bg-black/60 relative px-8 py-4 shadow-lg shadow-black/30 rounded-sm">
      <div class="inner-content">
        <div class="flex justify-between w-full pb-4">
          <div class="text-white uppercase mt-5"><slot name="scenario"></slot></div>
          <div class="uppercase text-white"><slot name="title"> </slot></div>
        </div>
        <div class="w-full" ref="canvasp5container">
          <canvas ref="canvasp5" class="w-full"> </canvas>
        </div>

        <div class="flex justify-between w-full pt-4 text-white">
          <div>
            {{ props.number }} days/year
            <div class="flex flex-row mt-1">
              <div
                class="h-4 bg-white"
                :style="{
                  width: props.number + 'px'
                }"
              ></div>
              <div
                class="h-4 bg-white/20"
                :style="{
                  width: 365 - props.number + 'px'
                }"
              ></div>
            </div>
          </div>

          <div class=" text-yellow-300 font-bold text-2xl"><slot name="year"></slot></div>
        </div>
      </div>
    </div>
  </div>
</template>
