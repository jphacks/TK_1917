<template>
  <Promised :promise="asyncChartData">
    <template v-slot:pending>
      <v-progress-circular :size="50" color="primary" indeterminate />
    </template>
    <template v-slot="chartData">
      <v-layout column justify-center align-center>
        <v-flex xs12 sm8 md6>
          <div class="text-xs-center">
            <ChartLine
              :height="450"
              :width="800"
              :chart-data="chartData"
              :options="options"
            />
          </div>
        </v-flex>
      </v-layout>
    </template>
    <template v-slot:rejected="error">
      <span class="headline">😢ばぐっちゃった🙇‍</span>
    </template>
  </Promised>
</template>

<script>
import { Promised } from 'vue-promised'
import ChartLine from '@/components/ChartLine'
import api from '@/utils/apiClient'

export default {
  components: {
    ChartLine,
    Promised
  },
  data() {
    return {
      asyncChartData: this.fetch(),
      options: {
        plugins: {
          colorschemes: {
            scheme: 'brewer.Accent3'
          }
        },
        legend: {
          // 凡例設定
          display: false // 表示設定
        },
        title: {
          // タイトル設定
          display: true, // 表示設定
          fontSize: 18, // フォントサイズ
          text: '過去6時間のキー入力推移' // ラベル
        }
      }
    }
  },
  methods: {
    async fetch() {
      const res = await api.get('visialization/key')
      const keys = res.data
      const labels = keys.map(k =>
        new Date(k.createdAt).toLocaleTimeString('ja')
      )
      const data = keys.map(k => k.typeCount)
      return {
        labels,
        datasets: [
          {
            fillColor: 'red',
            data,
            backgroundColor: 'rgba(255,255,255,0)'
          }
        ]
      }
    },
    unique(l) {
      return l.filter((x, i, self) => self.indexOf(x) === i)
    },
    labelColors(size) {
      const colors = []
      const templateColor = [
        '#FF4444',
        '#4444FF',
        '#44BB44',
        '#FFFF44',
        '#FF44FF'
      ]
      for (const i in size) {
        colors.push(templateColor[i % templateColor.length])
      }
      return colors
    }
  }
}
</script>
