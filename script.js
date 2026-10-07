document.getElementById('csvFile').addEventListener('change', function(event) {
    const file = event.target.files[0];

    if (!file) {
        return;
    }

    const reader = new FileReader();

    reader.onload = function(e) {
        const csvData = e.target.result;
        displayCSV(csvData);
    };

    reader.readAsText(file);
});

function displayCSV(csv) {
    const table = document.getElementById('csvTable');
    table.innerHTML = '';

    const rows = csv.split('\n');

    rows.forEach(row => {
        const tr = document.createElement('tr');

        row.split(',').forEach(col => {
            const td = document.createElement('td');
            td.textContent = col.trim();
            tr.appendChild(td);
        });

        table.appendChild(tr);
    });
}