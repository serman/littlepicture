<script setup>
import p5 from 'p5'
import { ref } from 'vue'
import { useElementSize } from '@vueuse/core'

const props = defineProps({
  number: {
    type: Number,
    default: 96
  }
})

const canvasp5 = ref(null)
const { width } = useElementSize(canvasp5)

const sketch = (s) => {
  let x = 100
  let theta = s.random(0, 2 * Math.PI)
  let thetainc = s.random(0.03, 0.1)
  let theta2 = 0
  let theta2inc = s.random(0.01, 0.04)
  s.setup = () => {
    s.createCanvas(width.value, 150, 'P2D', canvasp5.value)
  }

  s.draw = () => {
    s.clear()
    theta += thetainc
    theta2 += theta2inc
    s.fill(255)
    // lets draw a sin wave
    s.noFill()
    s.stroke(255, 255, 255, 128)
    s.beginShape()
    const numberofWaves = props.number
    const waveheight = s.height * 0.8
    if (x < s.width) x += 10
    for (let i = 0; i < x; i++) {
      s.vertex(
        i,
        waveheight / 2 +
          (s.noise(i / 5, 0.5) * waveheight) / 6 +
          (s.sin(numberofWaves * (i / s.width) * 2 * Math.PI + theta) * waveheight) / 2
      )
    }
    s.endShape()
  }
}

let myp5 = new p5(sketch)
</script>

<template>
  <div class="w-full">
    <div class="bg-black/40 relative px-8 py-4 shadow-lg shadow-black/30 rounded-sm">
      <div class="inner-content">
        <div class="flex justify-between w-full pb-4">
          <div class="text-yellow-300 font-bold text-lg"><slot name="year"></slot></div>
          <div class="uppercase"><slot name="title"> </slot></div>
        </div>
        <canvas id="canvasp5" ref="canvasp5" class="w-full"> </canvas>

        <div class="flex justify-between w-full pt-4">
          <div>
            {{ props.number }} days/year
            <div class="flex flex-row">
              <div
                class="h-4 bg-yellow-300"
                :style="{
                  width: props.number + 'px'
                }"
              ></div>
              <div
                class="h-4 bg-[#3C5451]"
                :style="{
                  width: 365 - props.number + 'px'
                }"
              ></div>
            </div>
          </div>

          <div class="text-yellow-300 uppercase"><slot name="scenario"></slot></div>
        </div>
      </div>
    </div>
  </div>
</template>
