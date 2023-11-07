<script setup>
import * as THREE from 'three'
import { onMounted } from 'vue'
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




const scene = new THREE.Scene()
const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000)
camera.position.z = 5

const renderer = new THREE.WebGLRenderer({
  powerPreference: 'high-performance',
  antialias: false,
  stencil: false,
  depth: false,
  alpha:false,
  
})
renderer.domElement.id = 'threejsCanvas';
renderer.setSize(window.innerWidth, window.innerHeight)
document.body.appendChild(renderer.domElement)

const geometry = new THREE.PlaneGeometry(20, 20)
const texture = new THREE.TextureLoader().load('/VIALES.png')
const material = new THREE.MeshBasicMaterial({ map: texture, opacity: 0.2, transparent: true })

const plane = new THREE.Mesh(geometry, material)
plane.position.y = 0
plane.rotation.x = 0
plane.rotation.z = 0
scene.add(plane)

const light = new THREE.AmbientLight(0xffffff)
scene.add(light)

let cameraAngle = 0
let cameraMoveUp = true

const fxaaEffect = new FXAAEffect()
const noiseEffect = new NoiseEffect({ premultiply: true })
const gridEffect = new GridEffect({ scale: 0.6 })
const vignetEffect = new VignetteEffect({ offset: 0.1, darkness: 0.5 })
const bloomEffect = new BloomEffect({ opacity: 1, blendFunction: BlendFunction.SCREEN })
fxaaEffect.minEdgeThreshold = 0.01
noiseEffect.blendMode.opacity.value = 1
noiseEffect.blendMode.blendFunction = BlendFunction.MULTIPLY

const loader = new THREE.TextureLoader();
const bgTexture = loader.load('/Gradient.png');

scene.background = bgTexture;

const effectPass = new EffectPass(camera,   noiseEffect, vignetEffect, bloomEffect)
const renderPass = new RenderPass(scene, camera);

const composer = new EffectComposer(renderer)
composer.addPass(renderPass)
composer.addPass(effectPass)



onMounted(() => {
  function animate() {
    requestAnimationFrame(animate)
   
    camera.position.x = 2
    camera.position.y = 5 * Math.sin(cameraAngle/ 5)
    camera.position.z = 10 + cameraAngle
    camera.lookAt(cameraAngle, cameraAngle, 0)
    if (cameraMoveUp === true) {
      cameraAngle += 0.0005
      if (cameraAngle > 1.5) {
        cameraMoveUp = false
      }
    } else {
      cameraAngle -= 0.0005
      if (cameraAngle < -1.5) {
        cameraMoveUp = true
      }
    }
     composer.render()

   // renderer.render(scene, camera)
  }
  animate()
})
</script>
<template>
    <div>

    </div>
</template>

<style lang="css" >
#threejsCanvas{
    position: fixed;
    top: 0;
    left: 0;
    z-index: -1;
}

</style>
