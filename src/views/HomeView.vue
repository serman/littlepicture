<script setup>
import singleSineWave from '../components/singleSineWave.vue'
import bgMap from '../components/bgMap.vue'

import csv from '../assets/heatWave_dict_rcp_all.csv'
import { ref } from 'vue';

console.log(csv)
const city = ref('Madrid')
const maxYear = '2085'
const rowGrandma = csv.find((d) => d.city === city.value && d.RCP == '45' && d.year == '1986')
const rowGrandson45 = csv.find((d) => d.city === city.value && d.RCP == '45' && d.year == maxYear)
const rowGrandson85 = csv.find((d) => d.city === city.value && d.RCP == '85' && d.year == maxYear)

// get all cities from the csv
const cities = [...new Set(csv.map((d) => d.city))]
console.log(cities)
console.log(rowGrandma, rowGrandson45, rowGrandson85)

// interface 
const showDropdown = ref(false)
</script>

<template>
  <div class="bg1">
    <div class="container max-w-screen-xl mx-auto">
      <div class="inline-block">
        <div class="text-8xl grow-0 text-white">HEATWAVES</div>
        <div class="justify-between flex shrink font-bold text-2xl text-yellow-300">
          <div class="relative inline-block text-left">
            <button
              id="dropdown-button"
              @click.prevent="showDropdown = !showDropdown"
              class="inline-flex justify-center w-full  py-2 font-medium text-yellow-300 bg-transparent focus:outline-none uppercase"
            >
              {{city}}
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="w-5 h-5 -mr-1"
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
              :class="{'hidden': !showDropdown }"
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
                  class="block px-4 py-2 mb-1 text-gray-700  hover:bg-yellow-300 text-3xl"
                  role="menuitem"
                  @click.prevent="city = _city; showDropdown = false"
                  >{{ _city }}</a
                >               
               
              </div>
            </div>
          </div>
          <span>1986-2085</span>
        </div>
      </div>
      <div class="flex flex-col gap-12 mb-96">
        <singleSineWave :number="parseInt(rowGrandma.value)">
          <template #title> When my mother was in her 20s </template>
          <template #year> 1986 </template>
        </singleSineWave>

        <singleSineWave :number="parseInt(rowGrandson45.value)">
          <template #title> When my grandaughter be in her 20s </template>
          <template #year> 2085 </template>
          <template #scenario> SCENARIO: RCP4.5 EMISIONS PEAKS AT 2040</template>
        </singleSineWave>

        <singleSineWave :number="parseInt(rowGrandson85.value)">
          <template #title>When my grandaughter be in her 20s </template>
          <template #year> 2085 </template>
          <template #scenario> SCENARIO: RCP8.5 emissions keep growing</template>
        </singleSineWave>
      </div>
    </div>
    <bgMap></bgMap>
  </div>
</template>

<style scoped></style>
