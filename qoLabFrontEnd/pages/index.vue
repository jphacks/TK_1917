<template>
  <v-layout column justify-center align-center>
    <v-flex xs12 sm8 md6>
      <div class="text-xs-center">
        <div class="container">
          <DomainChart />
        </div>
        <div class="container">
          <AppChart />
        </div>
        <div class="container">
          <KeyChart />
        </div>
      </div>
    </v-flex>
  </v-layout>
</template>

<script>
import DomainChart from '@/components/DomainChart'
import AppChart from '@/components/AppChart'
import KeyChart from '@/components/KeyChart'

export default {
  middleware: 'auth',
  components: {
    DomainChart,
    AppChart,
    KeyChart
  }
}
</script>

<style>
.container {
  margin: 30px auto;
}
</style>
