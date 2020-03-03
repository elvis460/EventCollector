import Vue from 'vue/dist/vue.esm';
import TurbolinksAdapter from 'vue-turbolinks';
import axios from 'axios';

export default document.addEventListener('turbolinks:load', () => {
  axios.defaults.headers.common['X-CSRF-Token'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  const element = document.getElementById('events');

  const events = new Vue({
    el: element,
    mixin: [TurbolinksAdapter],
    data() {
      return {
        events: {},
        dateList: [],
        currentExtractFilter: 'all',
        query: '',
        ssDate: ''
      };
    },
    created() {
      axios
        .get('/events.json')
        .then(response => {
          this.events = response.data.events;
          this.dateList = response.data.date_list;
        })
        .catch(error => {
          console.log(error);
          this.events = {}
          this.dateList = []
        });
    },
    mounted() {
      $('.datepicker').datepicker().on('changeDate', (e) => {
        this.dateFilter = e.target.value;
        this.filterEvents();
      });
    },
    methods: {
      filterChanged(filter) {
        if (filter === 'all') {
          // clear filters
          $('.datepicker').datepicker('setDate', '');
          this.query = '';
          this.dateFilter = '';
        }
        this.currentExtractFilter = filter;
        this.filterEvents();
      },
      filterEvents() {
        axios
          .get('/events.json', {
            params: {
              extract_filter: this.currentExtractFilter,
              date_filter: this.dateFilter,
              query: this.query
            }
          })
          .then(response => {
            this.events = response.data.events;
            this.dateList = response.data.date_list;
          })
          .catch(error => {
            console.log(error);
            this.events = {}
            this.dateList = []
          });
      },
      queryFilter() {
        if (this.query !== '') this.filterEvents();        
      }
    }
  });
});
