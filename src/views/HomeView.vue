<script setup>
import singleSineWave from '../components/singleSineWave.vue'
import bgMap from '../components/bgMap.vue'

import csv from '../assets/heatWave_dict_rcp_all.csv'
import { ref, onMounted, watch, computed } from 'vue'

const city = ref('Madrid')
const maxYear = '2085'
// const rowGrandma = csv.find((d) => d.city === city.value && d.RCP == '45' && d.year == '1986')
// const rowGrandson45 = csv.find((d) => d.city === city.value && d.RCP == '45' && d.year == maxYear)
// const rowGrandson85 = csv.find((d) => d.city === city.value && d.RCP == '85' && d.year == maxYear)

const rowGrandma = computed(() =>
  csv.find((d) => d.city === city.value && d.RCP == '45' && d.year == '1986')
)
const rowGrandson45 = computed(() =>
  csv.find((d) => d.city === city.value && d.RCP == '45' && d.year == maxYear)
)
const rowGrandson85 = computed(() =>
  csv.find((d) => d.city === city.value && d.RCP == '85' && d.year == maxYear)
)

const maxWaves = computed(() =>
  Math.max(rowGrandma.value.value, rowGrandson45.value.value, rowGrandson85.value.value)
)
// get all cities from the csv
const cities = [...new Set(csv.map((d) => d.city))]

// interface
const showDropdown = ref(false)

// scene management

const status = ref('loading') // loading, displaying, error
onMounted(() => {
  // setTimeout(() => {
  //   status.value = 'displaying'
  // }, 4000)
})

watch(
  () => city.value,
  () => {
    status.value = 'loading'
    setTimeout(() => {
      status.value = 'displaying'
    }, 4000)
  }
)
</script>

<template>
  <div class="bg1">
    <div class="container max-w-screen-xl mx-auto px-2">
      <div class="flex justify-between items-center gap-12 mb-8 mt-4">
        <div class="inline-block">
          <div class="text-8xl grow-0 text-white relative z-10">HEATWAVES</div>
          <div class="justify-between flex shrink font-bold text-2xl text-yellow-300 -mt-4">
            <div class="relative inline-block text-left">
              <button
                id="dropdown-button"
                @click.prevent="showDropdown = !showDropdown"
                class="inline-flex bg-yellow-300 justify-center w-full pt-2 font-medium text-black bg-transparent focus:outline-none uppercase transition-all duration-700 border-b-2 border-dotted border-black hover:border-black "
                :class="[status === 'loading' ? 'opacity-0' : 'opacity-100']"
              >
                {{ city }}
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  class="w-8 h-8 -mr-1"
                  viewBox="0 0 20 20"
                  fill="currentColor"
                  aria-hidden="true"
                >
                  <path
                    fill-rule="evenodd"
                    d="M6.293 9.293a1 1 0 011.414 0L10 11.586l2.293-2.293a1 1 0 111.414 1.414l-3 3a1 1 0 01-1.414 0l-3-3a1 1 0 010-1.414z"
                    clip-rule="evenodd"
                  />
                </svg>
              </button>
              <div
                id="dropdown-menu"
                class="origin-top-left transition-all absolute left-0 mt-2 w-56 bg-white/70 z-10 shadow-2xl shadow-yellow-300/50"
                :class="{ hidden: !showDropdown }"
              >
                <div
                  class=""
                  role="menu"
                  aria-orientation="vertical"
                  aria-labelledby="dropdown-button"
                  v-for="_city in cities"
                  :key="_city"
                >
                  <a
                    href="#"
                    class="block px-4 py-2 mb-1 text-gray-700 hover:bg-yellow-300 text-3xl "
                    role="menuitem"
                    @click.prevent='city = _city;showDropdown = false'>
                    {{ _city }}</a
                  >
                </div>
              </div>
            </div>
            <span class="inline-block mt-1  text-yellow-300 leading-8">1986-2085</span>
          </div>
        </div>
        <div>
          <div class="max-w-xl font-semibold text-white text-lg text-right">
            <div>
              <span> Due to climate change, heatwaves will become increasingly frequent in Europe.</span>
              <br />
              <br />
              <span class="font-bold bg-yellow-300 text-black">
                Next generations' well-being depends on our actions today. <br/>Every degree matters.
              </span>

            </div>

          </div>
        </div>
      </div>
      <div class="flex justify-between">
              <div
                class="inline-flex justify-end gap-4 items-center text-sm font-bold bg-black/50 px-2 py-2 my-2 text-white"
              >
                <svg
                  width="41"
                  height="20"
                  viewBox="0 0 69 67"
                  fill="none"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <path
                    d="M1.14551 33.625L8.06091 8.91444C10.7867 -0.825539 24.5951 -0.825562 27.3209 8.91442L34.2363 33.625L41.1517 58.3356C43.8775 68.0755 57.6859 68.0756 60.4117 58.3356L67.3271 33.625"
                    class="stroke-yellow-300"
                    stroke-width="4"
                  />
                </svg>
                One wave represents one day of heatwave.
              </div>
              <div class=" bg-black/50 px-2 py-2 my-2 text-white font-bold text-sm mb-2">
                Choose <span class="bg-yellow-300 text-black font-bold"> city</span> and compare heatwave predictions across alternative emission scenarios.
              </div>
            </div>
      <div class="flex flex-col gap-3 mb-32">
        <Transition>
          <singleSineWave
            :number="parseInt(rowGrandma.value)"
            :maxWaves="maxWaves"
            v-if="status === 'displaying'"
          >
            <template #title> When <span class="bg-yellow-300 text-black">my mother</span> was in her twenties </template>
            <template #year> 1986 </template>
          </singleSineWave>
        </Transition>
        <Transition>
          <singleSineWave 
          class="mt-8"
            :number="parseInt(rowGrandson45.value)"
            :maxWaves="maxWaves"
            v-if="status === 'displaying'"
          >
            <template #title> When <span class="bg-yellow-300 text-black">my grandaughter</span> will be in her twenties </template>
            <template #year>  </template>
            <template #scenario>  SCENARIO: <span class="bg-yellow-300 text-black"> RCP4.5 EMISIONS PEAKS AROUND 2040 </span></template>
          </singleSineWave>
        </Transition>

        <Transition>
          <singleSineWave
            :number="parseInt(rowGrandson85.value)"
            :maxWaves="maxWaves"
            v-if="status === 'displaying'"
          >
            <template #title> </template>
            <template #year> 2085 </template>
            <template #scenario> SCENARIO: <span class="bg-yellow-300 text-black">  RCP8.5 emissions keep growing</span></template>
          </singleSineWave>
        </Transition>
        <Transition>
          <template v-if="status === 'loading'">
            <div class="mt-24">
              <div class="w-full h-screen">
                <div
                  class="margin-auto text-center text-[300px] text-black text-bold uppercase opacity-40"
                >
                  {{ city }}
                </div>
                <div
                  data-title="dot-pulse"
                  class="w-full flex justify-center text-center snippet -my-12"
                >
                  <div class="text-center mt-8 text-white">loading</div>
                  <div class="stage text-center">
                    <div class="dot-pulse"></div>
                  </div>
                </div>
              </div>
            </div>
          </template>
        </Transition>
   
      </div>
    </div>
    <footer class="bg-black/60 text-white py-16 px-4">
      
      
      <div class="max-w-screen-xl mx-auto">
        <div class="mb-8  text-xl">
          A <a  class="underline underline-offset-2 hover:text-yellow-400" href="https://en.wikipedia.org/wiki/Representative_Concentration_Pathway"> Representative Concentration Pathway (RCP) </a> is a greenhouse gas concentration (not emissions) trajectory adopted by the IPCC.

          <ul class="mb-2 list-disc ml-5 pt-2">
            <li>
              RCP 4.5 is described by the IPCC as an intermediate scenario. Emissions in RCP 4.5 peak around 2040, then decline. 
            </li>
            <li>
              In RCP 8.5 emissions continue to rise throughout the 21st century.
            </li>
          </ul>
        </div>
        <p class="mb-2">Data source: <a href="https://cds.climate.copernicus.eu/cdsapp#!/dataset/sis-heat-and-cold-spells?tab=overview" target="_blank" class="underline underline-offset-2 hover:text-yellow-400">https://cds.climate.copernicus.eu/cdsapp#!/dataset/sis-heat-and-cold-spells?tab=overview</a>
        </p>
        
        <p class="mb-2">Sergio Galán, (<a href="http://graphicmethod.studio" class="underline underline-offset-2 hover:text-yellow-400">The graphic Method</a>)  
        </p>

        <p>
          Made for <a href="https://climate.esa.int/en/littlepicturescompetition/" class="underline underline-offset-2 hover:text-yellow-400"> little pictures competition</a> by ESA Climate Office.
        </p>

        <p>
        </p>

      </div>
    </footer>
    <bgMap :city="city" @rotation-finished="status = 'displaying'" :status="status"></bgMap>
  </div>
</template>

<style scoped>
/* we will explain what these classes do next! */
.v-enter-active,
.v-leave-active {
  transition: opacity 0.5s ease;
}

.v-enter-from,
.v-leave-to {
  opacity: 0;
}

/**
 * ==============================================
 * Dot Pulse
 * ==============================================
 */
.dot-pulse {
  position: relative;
  left: -9999px;
  width: 10px;
  height: 10px;
  border-radius: 5px;
  background-color: #f2c94c;
  color: #f2c94c;
  box-shadow: 9999px 0 0 -5px;
  animation: dot-pulse 1.5s infinite linear;
  animation-delay: 0.25s;
}
.dot-pulse::before,
.dot-pulse::after {
  content: '';
  display: inline-block;
  position: absolute;
  top: 0;
  width: 10px;
  height: 10px;
  border-radius: 5px;
  background-color: #f2c94c;
  color: #f2c94c;
}
.dot-pulse::before {
  box-shadow: 9984px 0 0 -5px;
  animation: dot-pulse-before 1.5s infinite linear;
  animation-delay: 0s;
}
.dot-pulse::after {
  box-shadow: 10014px 0 0 -5px;
  animation: dot-pulse-after 1.5s infinite linear;
  animation-delay: 0.5s;
}

@keyframes dot-pulse-before {
  0% {
    box-shadow: 9984px 0 0 -5px;
  }
  30% {
    box-shadow: 9984px 0 0 2px;
  }
  60%,
  100% {
    box-shadow: 9984px 0 0 -5px;
  }
}
@keyframes dot-pulse {
  0% {
    box-shadow: 9999px 0 0 -5px;
  }
  30% {
    box-shadow: 9999px 0 0 2px;
  }
  60%,
  100% {
    box-shadow: 9999px 0 0 -5px;
  }
}
@keyframes dot-pulse-after {
  0% {
    box-shadow: 10014px 0 0 -5px;
  }
  30% {
    box-shadow: 10014px 0 0 2px;
  }
  60%,
  100% {
    box-shadow: 10014px 0 0 -5px;
  }
}
</style>
