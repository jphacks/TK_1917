<template>
  <v-layout column justify-center align-center>
    <v-flex xs12 sm8 md6>
      <div class="text-xs-center">
        <Pie
          v-if="activeAppData"
          :chart-data="activeAppData"
          :options="options"
        />
      </div>
    </v-flex>
  </v-layout>
</template>

<script>
import Pie from '@/components/Pie'
import api from '@/utils/apiClient'
import 'chartjs-plugin-colorschemes'

export default {
  components: {
    Pie
  },
  data() {
    return {
      activeAppData: null,
      options: {
        plugins: {
          colorschemes: {
            scheme: 'tableau.ClassicLight10'
          }
        },
        legend: {
          // 凡例設定
          display: true // 表示設定
        },
        title: {
          // タイトル設定
          display: true, // 表示設定
          fontSize: 18, // フォントサイズ
          text: 'アプリの使用時間（過去６時間）' // ラベル
        }
      }
    }
  },
  async created() {
    const res = await api.get('visialization/software')
    const activeAppData = res.data
    // const domains = this.unique(browsingData.map(d => d.domain))
    const datas = activeAppData
      .map(d => ({
        key: d.name,
        value: Math.floor(d.percentage)
      }))
      .sort((a, b) => b.value - a.value)
    const labels = datas.map(d => d.key)
    const data = datas.map(d => d.value)
    this.activeAppData = {
      labels,
      datasets: [
        {
          data,
          borderWidth: 0.5
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
