<template>
  <div class="wrapper">
    <!-- <div class="alert">
      <v-alert v-if="alert.type !== ''" :type="alert.type">
        {{ alert.msg }}
      </v-alert>
    </div> -->
    <h1>Create Lab</h1>
    <v-text-field
      v-model="labName"
      :disabled="isCreateLoading"
      :loading="isCreateLoading"
    />
    <v-btn :disabled="!canCreate" :loading="isCreateLoading" @click="createLab">
      create
    </v-btn>
  </div>
</template>

<script>
// TODO: middleware追加
export default {
  data() {
    return {
      labName: '',
      isCreateLoading: false,
      alert: {
        type: '',
        msg: ''
      }
    }
  },
  computed: {
    canCreate() {
      return this.labName !== ''
    }
  },
  methods: {
    showSuccessAlert() {
      this.alert.type = 'success'
      this.alert.msg = '作成に成功しました'
      setTimeout(() => {
        this.alert.type = ''
        this.alert.msg = ''
      }, 5000)
    },
    showErrorAlert() {
      this.alert.type = 'error'
      this.alert.msg = '作成に失敗しました'
      setTimeout(() => {
        this.alert.type = ''
        this.alert.msg = ''
      }, 5000)
    },
    async createLab() {
      this.isCreateLoading = true
      try {
        // TODO: utils axiosでかく
        await new Promise(resolve => {
          setTimeout(() => {
            resolve()
          }, 2000)
        })

        this.showSuccessAlert()
      } catch (e) {
        this.showErrorAlert()
        console.log(e)
      } finally {
        this.isCreateLoading = false
      }
    }
  }
}
</script>

<style scoped>
.v-text-field {
  width: 300px;
}
</style>
