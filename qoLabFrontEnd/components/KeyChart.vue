<template>
  <v-layout column justify-center align-center>
    <v-flex xs12 sm8 md6>
      <div class="text-xs-center">
        <LineChart
          v-if="browsingData"
          :height="450"
          :width="800"
          :chart-data="browsingData"
          :options="options"
        />
      </div>
    </v-flex>
  </v-layout>
</template>

<script>
import LineChart from '@/components/LineChart'
import api from '@/utils/apiClient'

export default {
  components: {
    LineChart
  },
  data() {
    return {
      browsingData: null,
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
  async created() {
    const res = await api.get('visialization/key')
    const keys = res.data
    const labels = keys.map(k => new Date(k.createdAt).toLocaleTimeString('ja'))
    const data = keys.map(k => k.typeCount)
    this.browsingData = {
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
  methods: {
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
