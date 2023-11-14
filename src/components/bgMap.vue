<script setup>
//https://anvaka.github.io/city-roads/?q=barcelona%2C&areaId=3600347950
import * as THREE from 'three'
import { onMounted, watch } from 'vue'
import {
  BloomEffect,
  EffectComposer,
  EffectPass,
  RenderPass,
  DepthOfFieldEffect,
  VignetteEffect,
  FXAAEffect,
  GridEffect,
  NoiseEffect,
  BlendFunction
} from 'postprocessing'

let geometry
let texture
let material
let plane

const props = defineProps({
  city: {
    type: String,
    default: 'Madrid'
  },
  status: {
    type: String,
    default: 'loading'
  }
})

const emits = defineEmits(['rotationFinished'])
const INITROTATION = Math.PI / 10
const scene = new THREE.Scene()
const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000)
camera.rotation.x = -INITROTATION
camera.rotation.z = -INITROTATION/2
camera.position.z = 5

const renderer = new THREE.WebGLRenderer({
  powerPreference: 'high-performance',
  antialias: false,
  stencil: false,
  depth: false,
  alpha: false
})
renderer.domElement.id = 'threejsCanvas'
renderer.setSize(window.innerWidth, window.innerHeight)
document.body.appendChild(renderer.domElement)

geometry = new THREE.PlaneGeometry(20, 20)
texture = new THREE.TextureLoader().load(`/${props.city.toLowerCase()}.png`)
material = new THREE.MeshBasicMaterial({ map: texture, opacity: 0.9, transparent: true })

plane = new THREE.Mesh(geometry, material)
plane.position.y = 0
plane.rotation.x = 0
plane.rotation.z = 0
scene.add(plane)

const light = new THREE.AmbientLight(0xffffff)
scene.add(light)

let cameraAngle = 0
let cameraInitRotation = 0
let cameraMoveUp = true

const fxaaEffect = new FXAAEffect()
const noiseEffect = new NoiseEffect({ premultiply: true })
const gridEffect = new GridEffect({ scale: 2 })
const vignetEffect = new VignetteEffect({ offset: 0.1, darkness: 0.5 })
const bloomEffect = new BloomEffect({ opacity: 1, blendFunction: BlendFunction.SCREEN })
fxaaEffect.minEdgeThreshold = 0.01
noiseEffect.blendMode.opacity.value = 1
noiseEffect.blendMode.blendFunction = BlendFunction.MULTIPLY

const loader = new THREE.TextureLoader()
const bgTexture = loader.load('/Gradient.png')

scene.background = bgTexture

const effectPass = new EffectPass(camera, gridEffect, noiseEffect, vignetEffect, bloomEffect)
const renderPass = new RenderPass(scene, camera)

const composer = new EffectComposer(renderer)
composer.addPass(renderPass)
composer.addPass(effectPass)

onMounted(() => {
  function animate() {
    requestAnimationFrame(animate)

    if (props.status === 'loading') {
      const step = 0.001
      cameraInitRotation += step
      camera.rotateZ(step)
      camera.rotateX(step*2)
      camera.position.x = 2
      camera.position.y = 5 * Math.sin(cameraAngle / 5)
      camera.position.z =  5+ 5*(  cameraInitRotation/INITROTATION ) + cameraAngle // distance
      camera.lookAt(cameraAngle, cameraAngle, 0)
    } else {
      camera.position.y = 5 * Math.sin(cameraAngle / 5)
      camera.position.z = 10 + cameraAngle
      camera.lookAt(cameraAngle, cameraAngle, 0)
    }
    if (cameraInitRotation*2 - INITROTATION  >= 0) {
      emits('rotationFinished')
    }

    if (cameraMoveUp === true) {
      cameraAngle += 0.0009
      if (cameraAngle > 2.5) {
        cameraMoveUp = false
      }
    } else {
      cameraAngle -= 0.0009
      if (cameraAngle < -2.5) {
        cameraMoveUp = true
      }
    }
    composer.render()

    // renderer.render(scene, camera)
  }
  animate()
})

watch(
  () => props.city,
  (newValue, oldValue) => {
    console.log('city changed', newValue, oldValue)
    // remove old city texture and layer and load the new one:
    scene.remove(plane)
    texture = undefined
    material = undefined

    texture = new THREE.TextureLoader().load(`/${props.city.toLowerCase()}.png`)
    material = new THREE.MeshBasicMaterial({ map: texture, opacity: 0.9, transparent: true })

    plane.material = material
    scene.add(plane)
  }
)
</script>
<template>
  <div></div>
</template>

<style lang="css">
#threejsCanvas {
  position: fixed;
  top: 0;
  left: 0;
  z-index: -1;
}
</style>
