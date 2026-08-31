const body = document.body;
const tabs = document.querySelectorAll('.concept-tab');
const toast = document.querySelector('#toast');
const dialog = document.querySelector('#createDialog');

function showToast(title = 'Changes saved', message = 'Your process has been updated.') {
  toast.querySelector('b').textContent = title;
  toast.querySelector('small').textContent = message;
  toast.classList.add('show');
  clearTimeout(showToast.timer);
  showToast.timer = setTimeout(() => toast.classList.remove('show'), 2600);
}

tabs.forEach(tab => tab.addEventListener('click', () => {
  tabs.forEach(item => item.classList.remove('active'));
  tab.classList.add('active');
  body.dataset.theme = tab.dataset.theme;
  localStorage.setItem('bpm-mockup-theme', tab.dataset.theme);
}));

const savedTheme = localStorage.getItem('bpm-mockup-theme');
if (savedTheme) document.querySelector(`[data-theme="${savedTheme}"]`)?.click();

document.querySelectorAll('#processRows tr').forEach(row => row.addEventListener('click', event => {
  if (event.target.matches('button,input')) return;
  document.querySelectorAll('#processRows tr').forEach(item => item.classList.remove('selected'));
  row.classList.add('selected');
  document.querySelector('#detailTitle').textContent = row.querySelector('b').textContent;
  document.querySelector('#detailCode').textContent = row.querySelector('small').textContent;
  document.querySelector('#detailPanel').classList.add('open');
}));

document.querySelectorAll('.detail-tabs button').forEach(tab => tab.addEventListener('click', () => {
  document.querySelectorAll('.detail-tabs button,.tab-content').forEach(item => item.classList.remove('active'));
  tab.classList.add('active');
  document.querySelector(`[data-content="${tab.dataset.tab}"]`).classList.add('active');
}));

document.querySelector('#createBtn').addEventListener('click', () => dialog.showModal());
document.querySelector('#continueBtn').addEventListener('click', event => {
  event.preventDefault();
  const name = document.querySelector('#newName').value.trim();
  if (!name) return document.querySelector('#newName').focus();
  dialog.close();
  showToast('Process created', `${name} is ready for approval steps.`);
});
document.querySelector('#saveBtn').addEventListener('click', event => {
  const button = event.currentTarget;
  if (button.textContent === 'Edit process') {
    document.querySelector('[data-tab="settings"]').click();
    button.textContent = 'Save changes';
  } else {
    button.textContent = 'Edit process';
    showToast();
  }
});
document.querySelector('#closeDetail').addEventListener('click', () => document.querySelector('#detailPanel').classList.remove('open'));

const fileInput = document.querySelector('#fileInput');
fileInput.addEventListener('change', () => {
  [...fileInput.files].forEach(file => {
    const item = document.createElement('div');
    item.innerHTML = `<span class="file-icon">FILE</span><p><b>${file.name}</b><small>${Math.max(1, Math.round(file.size / 1024))} KB · Added just now</small></p><button>×</button>`;
    document.querySelector('#files').append(item);
  });
  document.querySelector('#fileCount').textContent = `${document.querySelectorAll('#files > div').length} files`;
  showToast('Files attached', 'The supporting documents are ready to save.');
});
document.querySelector('#files').addEventListener('click', event => {
  if (!event.target.matches('button')) return;
  event.target.closest('div').remove();
  document.querySelector('#fileCount').textContent = `${document.querySelectorAll('#files > div').length} files`;
});

