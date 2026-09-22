# Analisis Perilaku Konsumen & Retensi Pelanggan E-Commerce (Proyek SQL)

Selamat datang di proyek analisis **Customer Behavior and Shopping Habits**! Repositori ini berisi skrip PostgreSQL lengkap dan wawasan bisnis yang dihasilkan dari analisis data transaksi sepanjang tahun 2023. Proyek ini disusun sebagai *Final Project* untuk **Bootcamp Master SQL for Data Analyst** oleh Genggam Data.

---

## Ringkasan & Tujuan Proyek
Sebagai seorang Data Analyst, tujuan dari proyek ini adalah untuk mendukung tim **Marketing, Growth, dan Business Development** dalam memberikan rekomendasi berbasis data guna mengoptimalkan penjualan, mengevaluasi efisiensi biaya promosi, serta memahami tantangan retensi pelanggan.

Proyek ini terbagi menjadi **5 cakupan analisis utama**:
1. **Descriptive Analysis** — Gambaran umum performa toko.
2. **Performance Sales & Growth Analysis** — Mengidentifikasi tren penjualan bulanan dan dinamika pertumbuhan kategori produk.
3. **Promotional Cost Efficiency Analysis** — Memantau efektivitas biaya promosi (*Burn Rate*) terhadap batas maksimum perusahaan (43%).
4. **Customer Retention (Cohort) Analysis** — Menilai retensi pelanggan dan tingkat *churn* antar-periode.
5. **Customer Behavior Analysis** — Menganalisis preferensi produk berdasarkan demografi (gender) dan menguji korelasi rating review.

---

## _Summary_ & _Main Business Insight_

* **Tantangan Retensi Pelanggan:** Hasil *Cohort Analysis* menunjukkan penurunan drastis pada loyalitas pelanggan. Rata-rata **lebih dari 50% pelanggan baru berhenti melakukan pembelian (*churn*) setelah bulan pertama**. Fokus bisnis harus digeser ke program loyalitas pasca-pembelian pertama.
* **Pengeluaran Promosi Berlebih (*Burn Rate*):** Pada semester pertama 2023, efisiensi promosi berada di tingkat yang merugikan. ***Burn rate* tertinggi terjadi pada bulan Juni sebesar 47,16%**, melampaui batas maksimum manajemen sebesar **43%**. Pengendalian promosi baru membaik pada bulan Desember (43,35%).
* **Kampanye Iklan Berbasis Gender:** Produk *Pants*, *Blouse*, dan *Jewelry* merupakan barang yang paling sering dibeli secara umum (masing-masing 171 kali transaksi). Namun untuk efisiensi iklan, tim pemasaran disarankan menargetkan **audiens Pria untuk produk *Pants*, *Jewelry*, dan *Coat***, serta **audiens Wanita untuk produk *Blouse*, *Sandals*, dan *Shirt***.
* **Fluktuasi Penjualan & Peak Season:** Performa pendapatan cukup fluktuatif sepanjang tahun. Penjualan terendah terjadi pada bulan Juni ($9.451,20), sedangkan puncak penjualan (*peak season*) berhasil dicapai pada **Oktober ($12.303,98)**.
* **Paradoks Rating Review:** Pengujian korelasi Pearson antara *rating review* dan total jumlah pembelian menghasilkan nilai **$r = -0,00038$**. Hal ini membuktikan secara statistik bahwa keputusan pembelian pelanggan tidak dipengaruhi oleh nilai rating review.

---

## Tools & Dataset yang Digunakan
* **Database Management System:** PostgreSQL (via pgAdmin)
* **Alat Visualisasi:** Microsoft Excel / Google Sheets
* **Fitur Utama SQL:** Common Table Expressions (CTE), Window Functions (`LAG()`, `ROW_NUMBER()`), Agregasi (`SUM`, `COUNT DISTINCT`), Date Extractions (`EXTRACT`).
* **Dataset:** *Customer Behavior and Shopping Habits 2023* (3.900 baris transaksi, 551 _Unique Customers_).

---

## Detail Analisis

### 1. Descriptive Analysis (Gambaran Umum 2023)
* **Total Transaksi:** 3.900 transaksi
* **Jumlah Customer Unik:** 551 pelanggan
* **Total Pendapatan (Revenue):** \$128.673,73 *(setelah pemotongan diskon)*
* **Variasi Produk:** 4 kategori produk (25 jenis produk unik)
* **Rata-rata Usia Customer:** 23,96 tahun

### 2. Performance Sales & Growth Analysis
Formula pertumbuhan yang digunakan:
$$\text{Growth Percentage} = \left( \frac{\text{Order/Sales Periode Ini}}{\text{Order/Sales Periode Sebelumnya}} - 1 \right) \times 100$$

* **Bulan Performa Tinggi:** Bulan Maret (+13,13% Growth Order) dan Oktober (+9,85% Growth Order).
* **Bulan Performa Terendah:** Bulan Juni mengalami penurunan transaksi sebesar -13,06%, berbanding lurus dengan tingkat *burn rate* promosi tertinggi.

### 3. Promotional Cost Efficiency Analysis
Batas maksimum *burn rate* yang ditetapkan manajemen adalah **43%**.
$$\text{Burn Rate} = \left( \frac{\text{Total Nilai Diskon (USD)}}{\text{Total Sales Gross (USD)}} \right) \times 100$$

| Bulan | Total Sales ($) | Nilai Promosi ($) | Burn Rate (%) | Status |
|---|---|---|---|---|
| Januari | 19.547 | 8.677,53 | 44,39% | 🔴 Melebihi Batas |
| Juni | 17.740 | 8.366,08 | **47,16%** | 🔴 *Jauh Melebihi Batas* |
| Oktober | 21.792 | 9.488,02 | 43,54% | 🟡 Mendekati Batas |
| Desember | 18.725 | 8.116,82 | **43,35%** | 🟢 Mendekati Target |

### 4. Customer Retention Analysis (Cohort Framework)
* **Retention Rate (%):** Pelanggan yang bergabung di bulan Januari (Cohort 1) hanya menyisakan 43% pelanggan aktif di bulan kedua (m1).
* **Churn Rate (%):** Rata-rata tingkat *churn* di hampir semua kelompok bulan berada di atas 50% setelah bulan pertama, mengindikasikan bahwa mayoritas pelanggan hanya bertransaksi satu kali.

### 5. Customer Behavior & Preferences
* **3 Produk Paling Laris:** *Pants*, *Blouse*, dan *Jewelry* (masing-masing 171 kali pembelian).
* **Peringkat Preferensi Gender:**
  * **Pria (Male):** Pants ➡️ Jewelry ➡️ Coat
  * **Wanita (Female):** Blouse ➡️ Sandals ➡️ Shirt
* **Penggunaan Diskon:** Sebanyak 3.883 dari total 3.900 transaksi menggunakan diskon aplikasi.

---

## Rekomendasi Strategis untuk Bisnis

1. **Program Retensi Pelanggan:** Atasi *churn rate* yang mencapai >50% dengan memberikan voucher khusus pembelian kedua (*second-purchase incentive*) untuk mendorong *repeat order*.
2. **Evaluasi Alokasi Promosi:** Kurangi pemberian diskon umum pada pertengahan tahun (khususnya bulan Juni) dan alihkan ke promosi berbasis segmentasi perilaku pelanggan.
3. **Personalisasi Iklan Digital:** Sesuaikan materi iklan dengan preferensi gender—tampilkan koleksi *Coat* dan *Pants* untuk pengguna pria, serta *Blouse* dan *Sandals* untuk pengguna wanita.

---

## Struktur Repositori
```bash
├── Script.sql          # Kode PostgreSQL lengkap yang terstruktur rapi
└── README.md           # Dokumentasi analisis dan rekomendasi bisnis
