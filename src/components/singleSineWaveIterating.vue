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
  
  let theta = s.random(0, 2 * Math.PI  )
  let thetainc = s.random(0.03, 0.1)
  let theta2 = 0;
  let theta2inc = s.random(0.01, 0.04  )
  s.setup = () => {
    s.createCanvas(width.value, 150, 'P2D', canvasp5.value)
  }

  s.draw = () => {
    s.clear()
    theta+= thetainc
    theta2 += theta2inc
    s.fill(255)
    // lets draw a sin wave
    s.noFill()
    s.stroke(255, 255, 255, 128)
    const numberofWaves = props.number
    const wavesWidth = getWavesWidth(numberofWaves)
    s.beginShape() 
    // if (x < wavesWidth) x += 10
    // first we just draw white noise, then the sin waves in the middle and then white noise again
    for(let i = 0; i < (s.width - wavesWidth)/2; i++) {
      s.vertex(i,  s.noise(i/100, theta) * s.height/5 + s.height / 2.5 )
    }

    for (let i = (s.width - wavesWidth)/2; i < (s.width - wavesWidth)/2 + wavesWidth; i++) {
      s.vertex(
        i,
        s.height / 2 +  s.noise(i/100, theta2) * s.height/5 + (s.sin(numberofWaves/6 * (i / wavesWidth) * 2 * Math.PI) * s.height) / 2
      )
    }
    for (let i = (s.width - wavesWidth)/2 + wavesWidth; i < s.width; i++) {
      s.vertex(i,  s.noise(i/100, theta2) * s.height/5 + s.height / 2.5 )
    }
    s.endShape()
  }
  // we consider s.width the total available space that represents a full year
  // each wave is three days
  function getWavesWidth(daysHeatwave) {
    return s.width/365 * daysHeatwave
  }
}

// 

let myp5 = new p5(sketch)
</script>

<template>
  <div class="w-full">
    <div class="bg-black/40 relative px-8 py-4 shadow-lg shadow-black/30 rounded-sm">
      <div class="inner-content">
        <div class="flex justify-between w-full pb-4">
          <div><slot name="title"> </slot></div>
          <div><slot name="year"></slot></div>
        </div>
        <canvas id="canvasp5" ref="canvasp5" class="w-full"> </canvas>

        <div class="flex justify-between w-full pt-4">
          <div>
            {{ props.number }} dias/año
            <div
              class="absolute h-12 bg-[#3C5451/50]"
              style="{
            width: props.number * 10     + 'px',
            }"
            ></div>
          </div>

          <div class="text-yellow-300"><slot name="scenario"></slot></div>
        </div>
      </div>
    </div>
  </div>
</template>
