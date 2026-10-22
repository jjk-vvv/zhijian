import { chromium, devices } from '@playwright/test'
import { existsSync, mkdirSync } from 'node:fs'
import { resolve } from 'node:path'

const chrome = 'C:/Program Files/Google/Chrome/Application/chrome.exe'
const browser = await chromium.launch(existsSync(chrome) ? { executablePath: chrome } : {})
const output = resolve('../preview')
mkdirSync(output, { recursive: true })
for (const mobile of [false, true]) {
  const page = await browser.newPage(
    mobile
      ? { ...devices['iPhone 13'], defaultBrowserType: 'chromium' }
      : { viewport: { width: 1440, height: 1100 }, deviceScaleFactor: 1 },
  )
  for (const [name, path] of [
    ['discover', '/'],
    ['shelf', '/#/shelf'],
    ['notes', '/#/notes'],
  ]) {
    await page.goto(`http://127.0.0.1:4174${path}`, { waitUntil: 'networkidle' })
    await page.screenshot({
      path: resolve(output, `${name}-${mobile ? 'mobile' : 'desktop'}.png`),
      fullPage: true,
    })
    console.log(
      name,
      mobile ? 'mobile' : 'desktop',
      await page.evaluate(() => ({
        width: innerWidth,
        scrollWidth: document.documentElement.scrollWidth,
        imagesLoaded: [...document.images].every(
          (image) => image.complete && image.naturalWidth > 0,
        ),
      })),
    )
  }
  await page.close()
}
await browser.close()
