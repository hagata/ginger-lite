{% include 'header/header.html' %}
<body>
    <div class="content">
        {% include 'nav/nav.html' %}
        {% block content %} {% endblock %} 
        {% include 'footer/footer.html' %}
    </div>
</body>
</html>