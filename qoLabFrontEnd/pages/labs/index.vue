<template>
  <div class="wrapper">
    <div class="alert">
      <v-alert
        v-show="showAlert"
        transition="scale-transition"
        :type="alertType"
      >
        {{ alertMsg }}
      </v-alert>
    </div>
    <div v-if="!lab" class="create-container">
      <h1>Create Lab</h1>
      <v-text-field
        v-model="labName"
        :disabled="isCreateLoading || canCreateByCode"
        :loading="isCreateLoading"
        placeholder="研究室名を入力してね"
      />
      <v-btn
        :disabled="!canCreate"
        :loading="isCreateLoading"
        @click="createLab"
      >
        create
      </v-btn>
      <h1>Join Lab by LabCode</h1>
      <v-text-field
        v-model="labCode"
        :disabled="isCreateLoading || canCreate"
        :loading="isCreateLoading"
        placeholder="研究室コードを入力してね"
      />
      <v-btn
        :disabled="!canCreateByCode"
        :loading="isCreateLoading"
        @click="createLab"
      >
        create
      </v-btn>
    </div>
    <div v-else class="created-container">
      <p class="title">同じ研究室のみんなで共有してね</p>
      <p class="headline">labcode: {{ lab.labCode }}</p>

      <nuxt-link :to="`/labs/${lab._id}`">
        <v-btn>{{ lab.name }}の設定をする</v-btn>
      </nuxt-link>

      <v-btn :loading="isLeaveLoading" @click="leaveLab">
        このラボルームから脱退する
      </v-btn>
    </div>
  </div>
</template>

<script>
import api from '@/utils/apiClient'
export default {
  middleware: 'auth',
  data() {
    return {
      labName: '',
      labCode: '',
      isCreateLoading: false,
      isLeaveLoading: false,
      alertType: '',
      alertMsg: '',
      lab: null
    }
  },
  computed: {
    canCreate() {
      return this.labName !== '' && !this.canCreateByCode
    },
    canCreateByCode() {
      return this.labCode !== '' && !this.canCreate
    },
    showAlert() {
      return this.alertType !== ''
    }
  },
  async asyncData() {
    const res = await api.get('lab')
    return { lab: res.data }
  },
  methods: {
    showSuccessAlert() {
      this.alertType = 'success'
      this.alertMsg = '作成に成功しました'
      setTimeout(() => {
        this.alertType = ''
        this.alertMsg = ''
      }, 5000)
    },
    showErrorAlert() {
      this.alertType = 'error'
      this.alertMsg = '作成に失敗しました'
      setTimeout(() => {
        this.alertType = ''
        this.alertMsg = ''
      }, 5000)
    },
    async createLab() {
      this.isCreateLoading = true
      try {
        await api.post('lab', {
          name: this.labName,
          labCode: this.labCode
        })
        this.showSuccessAlert()
      } catch (e) {
        this.showErrorAlert()
      } finally {
        this.isCreateLoading = false
        const res = await api.get('lab')
        this.lab = res.data
      }
    },
    async leaveLab() {
      this.isLeaveLoading = true
      try {
        await api.delete('lab')
        this.showSuccessAlert()
      } catch (e) {
        this.showErrorAlert()
      } finally {
        this.isLeaveLoading = false
        const res = await api.get('lab')
        this.lab = res.data
      }
    }
  }
}
</script>

<style scoped>
.v-text-field {
  width: 300px;
}
.v-alert {
  margin-bottom: 24px;
}
</style>
