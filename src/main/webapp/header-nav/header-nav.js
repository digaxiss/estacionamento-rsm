/**
 * Função para carregamento simplificado do header-nav
 * @param {string} containerId - ID do elemento onde o header será carregado
 * @param {string} currentPage - Nome da página atual para ativar no menu
 */
function loadHeaderNav(containerId = 'header-nav-container', currentPage = '') {
  document.addEventListener('DOMContentLoaded', function () {
    const container = document.getElementById(containerId)
    if (!container) {
      console.error('Container do header não encontrado:', containerId)
      return
    }

    // Determinar o caminho para o header com base na página atual
    let headerPath = '../components/header-nav/header-nav.html'

    // Verificar quantos níveis precisamos subir com base no URL atual
    const pathSegments = window.location.pathname.split('/').filter(Boolean)
    const pagesIndex = pathSegments.findIndex((segment) => segment === 'Pages')

    if (pagesIndex >= 0) {
      const levelsUp = pathSegments.length - pagesIndex - 1
      headerPath =
        '../'.repeat(levelsUp) + 'components/header-nav/header-nav.html'
    }

    // Carregar o header
    fetch(headerPath)
      .then((response) => {
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`)
        }
        return response.text()
      })
      .then((html) => {
        // Inserir o HTML do header
        container.innerHTML = html

        // Ativar o link correto após um pequeno delay para garantir que o DOM foi atualizado
        setTimeout(() => {
          const links = document.querySelectorAll('.main-nav a')
          links.forEach((link) => {
            // Verificar por correspondência no texto ou no atributo data-page
            const linkPage =
              link.getAttribute('data-page') ||
              link.textContent.trim().toLowerCase()

            if (currentPage && linkPage.includes(currentPage.toLowerCase())) {
              link.classList.add('active')
            } else {
              link.classList.remove('active')
            }
          })
        }, 50)
      })
      .catch((error) => {
        console.error('Erro ao carregar o header:', error)
        container.innerHTML = `
          <div style="background-color: #1a1a1a; color: #ff5252; padding: 15px; text-align: center;">
            Erro ao carregar o menu. <a href="javascript:window.location.reload()" style="color: #40c4ff;">Recarregar página</a>
          </div>`
      })
  })
}
