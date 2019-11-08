<template>
  <v-layout column justify-center align-center fill-height>
    <Promised :promise="chartDatas">
      <template v-slot:pending>
        <v-progress-circular :size="50" color="primary" indeterminate />
      </template>
      <template v-slot="data">
        <h1 class="font-weight-black display-1 mb-2">WeeklyReport</h1>
        <p class="font-weight-light pa-1">1週間分の捗り具合を出すよ！</p>
        <Pie :chart-data="data.chartData" class="ma-1" />
        <v-tabs v-model="tab">
          <v-tab
            v-for="label in data.comments.labels"
            :key="label"
            class="ma-1"
          >
            {{ label }}
          </v-tab>
          <v-tabs-items v-model="tab">
            <v-tab-item
              v-for="comment in data.comments.comments"
              :key="comment"
            >
              <v-card flat tile>
                <v-card-text>{{ comment }}</v-card-text>
              </v-card>
            </v-tab-item>
          </v-tabs-items>
        </v-tabs>
      </template>
      <template v-slot:rejeted="error"> </template>
    </Promised>
  </v-layout>
</template>

<script>
import { Promised } from 'vue-promised'
import Pie from '@/components/Pie'
import api from '@/utils/apiClient'

export default {
  middleware: 'auth',
  components: { Promised, Pie },
  data() {
    return {
      chartDatas: this.fetchWeeklyData(),
      tab: null
    }
  },
  computed: {
    comments() {
      return ['hoge', 'huga', 'nyan', 'napo']
    }
  },
  methods: {
    async fetchWeeklyData() {
      const res = await api.get('/weekly-report')
      return res.data
    }
  }
}
</script>
