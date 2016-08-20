{% extends 'base.tpl' %}
  {% block content %}
  
  <h1>Ginger–Lite - ADMIN</h1>
  <h2>Admin restricted page</h2>

  <pre>
    hello {{nickname}}, {{user}}
  </pre>

<!-- [START enabled locale list] -->
  <div class="enabled-locales">
      <ul class="enabled-locales__list">
      {% for result in query_results %}  
        <li class="enabled-locales__list-item {% if result.enabled %} enabled{%endif%}">{{result.locale_id}}: {{result.enabled}}</li>
      {% endfor %}  
      </ul>
  </div>
<!-- [END enabled locale list] -->

<section>
  ALL LOCALES

  <form action="/admin/save-config" method="post">
  <ul class="locale-toggles">
    {% for locale in locales %}
      <li class="locale-toggles__toggle"><label><input type="checkbox" name="locale-toggle" value="{{locale.locale_id}}" {% if locale.enabled %}checked{% endif %}>{{locale.locale_id}}</label></li>
    {% endfor %}
  </ul>
  <input type="submit" value="SAVE"></input>
  </form>

  <form action="/admin/seed" method="post">
    <input type="hidden" value="seed">
    <input type="submit" value="SEED"></input>
  </form>

</section>

{% endblock %}