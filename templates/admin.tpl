{% extends 'base.tpl' %}
  {% block content %}
  
  <h1>Ginger–Lite - ADMIN</h1>
  <h2>Admin restricted page</h2>

  <p>
    The following is an example use-case of DataStore for setting/updating a sites global settings.
  </p>

<!-- [START DataStore Example enabled locale list] -->
<!--
    Shows list of DataStore Entities of type Locale, 
    with their enabled property set to true of false.
-->
<section>
  <div class="enabled-locales">
    <p>From DataStore:</p>
      <ul class="enabled-locales__list">
      {% for locale in locales %}  
        <li class="enabled-locales__list-item {% if locale.enabled %} enabled{%endif%}">{{locale.locale_id}}: {{locale.enabled}}</li>
      {% endfor %}  
      </ul>
  </div>
<!-- [Start Form for updating DataStore Entities-->
<!--
  The form action hits the post methond of the UpdateConfigHandler
  The form will also render with checked boxes for those locales
  set enabled=true in the DataStore
-->
  <form action="/admin/save-config" method="post">
  <p>Settings`</p>
  <ul class="locale-toggles">
    {% for locale in locales %}
      <li class="locale-toggles__toggle"><label><input type="checkbox" name="locale-toggle" value="{{locale.locale_id}}" {% if locale.enabled %}checked{% endif %}>{{locale.locale_id}}</label></li>
    {% endfor %}
  </ul>
  <input type="submit" value="SAVE CONFIG" class="admin-button"></input>
  </form>
<!--[End Update Form]-->
</section>

<section class="seed">
<p class="seed__description">
  When starting a new Appengine Project, or otherwise starting with an empty Database, this seed button calls a SeedHandler which mimics a RemoteAPI script to populate the database. 
</p>
  <form action="/admin/seed" method="post">
    <input type="hidden" value="seed">
    <input type="submit" 
            value="Populate Database" 
            class="admin-button {%if locales %}admin-button--disabled{%endif%}" 
            {%if locales %}disabled{%endif%}>
            </input>
  </form>
</section>


{% endblock %}