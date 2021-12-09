const selectWikiArticle = (urlFields) => {
  urlFields.forEach(element => {
    new TomSelect(element, {
      closeAfterSelect: true,
      valueField: 'url',
      labelField: 'suggestion',
      searchField: 'suggestion',
      maxItems: 1,
      // fetch remote data
      load: function (query, callback) {
        var url = 'https://en.wikipedia.org/w/api.php?action=opensearch&format=json&origin=*&limit=6&search=' + encodeURIComponent(query);
        fetch(url)
          .then(response => response.json())
          .then(json => {
            const options = []
            json[1].map((element, index) => {
              options.push({
                id: index,
                suggestion: element,
                url: json[3][index].split('/').pop()
              })
            });
            callback(options);
          }).catch(() => {
            callback();
          });

      },
      // custom rendering functions for options and items
      render: {
        option: function (item, escape) {
          return `<div class="py-1 d-flex">
                  <div>
                    <div class="mb-1">
                      <span class="p">
                        ${escape(item.suggestion)}
                      </span>
                    </div>
                  </div>
                </div>`;
        },
        item: function (item, escape) {
          return `<div class="py-1 d-flex">
                  <div>
                    <div class="mb-1">
                      <span class="p">
                        ${escape(item.suggestion)}
                      </span>
                    </div>
                  </div>
                </div>`;
        }
      },
    });
  });
};

export { selectWikiArticle }
