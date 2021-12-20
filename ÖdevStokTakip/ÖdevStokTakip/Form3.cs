using Npgsql;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ÖdevStokTakip
{
    public partial class Form3 : Form
    {
        public Form3()
        {
            InitializeComponent();
        }
        NpgsqlConnection baglanti = new NpgsqlConnection("server=localhost; port=5432; Database=odevstok; user ID=postgres; password=hakan369212");
        void kategoridoldur()
        {
            baglanti.Open();
            NpgsqlDataAdapter da = new NpgsqlDataAdapter("select* from kategoriler", baglanti);
            DataTable dt = new DataTable();
            da.Fill(dt);
            comboBox1.DisplayMember = "kategoriad";
            comboBox1.ValueMember = "kategoriid";
            comboBox1.DataSource = dt;
            baglanti.Close();
        }
        void markadoldur()
        {
            baglanti.Open();
            NpgsqlDataAdapter da = new NpgsqlDataAdapter("select* from markalar", baglanti);
            DataTable dt = new DataTable();
            da.Fill(dt);
            comboBox2.DisplayMember = "markadı";
            comboBox2.ValueMember = "markaid";
            comboBox2.DataSource = dt;
            baglanti.Close();
        }
        void bayidoldur()
        {
            baglanti.Open();
            NpgsqlDataAdapter da = new NpgsqlDataAdapter("select* from depo", baglanti);
            DataTable dt = new DataTable();
            da.Fill(dt);
            comboBox3.DisplayMember = "depoid";
            comboBox3.ValueMember = "depoid";
            comboBox3.DataSource = dt;
            baglanti.Close();
        }
        void sirketdoldur()
        {
            baglanti.Open();
            NpgsqlDataAdapter da = new NpgsqlDataAdapter("select* from sirketler", baglanti);
            DataTable dt = new DataTable();
            da.Fill(dt);
            comboBox4.DisplayMember = "sirketadi";
            comboBox4.ValueMember = "sirkerid";
            comboBox4.DataSource = dt;
            baglanti.Close();
        }
        private void Form3_Load(object sender, EventArgs e)
        {
            kategoridoldur();
            markadoldur();
            bayidoldur();
            sirketdoldur();

        }

        private void button2_Click(object sender, EventArgs e)
        {
            string sorgu =" SELECT * FROM urunler INNER JOIN urunlerbayi ON urunler.barkodno = urunlerbayi.urunid";
  
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, baglanti);
            DataSet ds = new DataSet();
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];
        }
        void stokekle()
        {
            baglanti.Open();
            NpgsqlCommand komut = new NpgsqlCommand("insert into urunlerbayi (urunid,bayiid,miktar) values (@p2,@p3,@p4)", baglanti);
           
            komut.Parameters.AddWithValue("@p2", textBox1.Text);
            komut.Parameters.AddWithValue("@p3", int.Parse(comboBox3.SelectedValue.ToString()));
            komut.Parameters.AddWithValue("@p4", int.Parse(textBox5.Text));
            
            
            komut.ExecuteNonQuery();
            baglanti.Close();
        }
        
        private void button1_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlCommand komut = new NpgsqlCommand("insert into urunler (barkodno,kategori,marka,urunadı,sirketid) values (@p1,@p2,@p3,@p4,@p5)", baglanti);
            komut.Parameters.AddWithValue("@p1", textBox1.Text);
            komut.Parameters.AddWithValue("@p2", int.Parse(comboBox1.SelectedValue.ToString()));
            komut.Parameters.AddWithValue("@p3", int.Parse(comboBox2.SelectedValue.ToString()));
            komut.Parameters.AddWithValue("@p4", textBox4.Text);
            komut.Parameters.AddWithValue("@p5", int.Parse(comboBox4.SelectedValue.ToString()));
            komut.ExecuteNonQuery();
            baglanti.Close();
            stokekle();
            MessageBox.Show("eklendi");

           
        }

        private void button4_Click(object sender, EventArgs e)
        {
            DialogResult dr = new DialogResult();
            dr = MessageBox.Show("Silmek istediğinize emin misiniz?", "", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            if (dr == DialogResult.Yes)
            {
                baglanti.Open();
                NpgsqlCommand komut = new NpgsqlCommand("delete from urunler where barkodno=@p1", baglanti);
                komut.Parameters.AddWithValue("@p1", textBox1.Text);
                komut.ExecuteNonQuery();
                baglanti.Close();
                MessageBox.Show("silindi");
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {

        }

       

        private void dataGridView1_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            int secilen = dataGridView1.SelectedCells[0].RowIndex;
            textBox1.Text = dataGridView1.Rows[secilen].Cells[0].Value.ToString();
            comboBox1.Text = dataGridView1.Rows[secilen].Cells[1].Value.ToString();
            comboBox2.Text = dataGridView1.Rows[secilen].Cells[2].Value.ToString();
            textBox4.Text = dataGridView1.Rows[secilen].Cells[3].Value.ToString();
         
            
        }

        private void button5_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            DataTable dt = new DataTable();
            NpgsqlDataAdapter ara = new NpgsqlDataAdapter("Select * from urunler " +
                "where barkodno like '%" + textBox3.Text + "%' ", baglanti);
            ara.Fill(dt);
            baglanti.Close();
            dataGridView1.DataSource = dt;
        }
    }
}
