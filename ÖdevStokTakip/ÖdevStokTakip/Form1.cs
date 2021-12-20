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
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }
        NpgsqlConnection baglanti = new NpgsqlConnection("server=localhost; port=5432; Database=odevstok; user ID=postgres; password=hakan369212");
        private void button1_Click(object sender, EventArgs e)
        {
            Form2 fr = new Form2();
            fr.Show();
        }
         private void doldurmüşteriler()
        {
            baglanti.Open();
            NpgsqlDataAdapter da = new NpgsqlDataAdapter("select* from musteri", baglanti);
            DataTable dt = new DataTable();
            da.Fill(dt);
            comboBox1.DisplayMember = "tc";
            comboBox1.ValueMember = "tc";
            comboBox1.DataSource = dt;
            baglanti.Close();
        }
        void doldurkargoad()
        {
            baglanti.Open();
            NpgsqlDataAdapter ka = new NpgsqlDataAdapter("select* from kargosirket", baglanti);
            DataTable kt = new DataTable();
            ka.Fill(kt);
            comboBox2.DisplayMember = "sirketad";
            comboBox2.ValueMember = "sirketid";
            comboBox2.DataSource = kt;
            baglanti.Close();
        }
        void personeldoldur()
        {
            baglanti.Open();
            NpgsqlDataAdapter pa = new NpgsqlDataAdapter("select* from personel", baglanti);
            DataTable pt = new DataTable();
            pa.Fill(pt);
            comboBox3.DisplayMember = "adısoyadı";
            comboBox3.ValueMember = "personelid";
            comboBox3.DataSource = pt;
            baglanti.Close();
        }
        void faturadoldur()
        {
            baglanti.Open();
            NpgsqlDataAdapter pa = new NpgsqlDataAdapter("select* from fatura", baglanti);
            DataTable pt = new DataTable();
            pa.Fill(pt);
            comboBox4.DisplayMember = "faturaid";
            comboBox4.ValueMember = "faturaid";
            comboBox4.DataSource = pt;
            baglanti.Close();
        }
        private void button2_Click(object sender, EventArgs e)
        {
            string sorgu = "select* from siparis";
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, baglanti);
            DataSet ds = new DataSet();
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void Form1_Load(object sender, EventArgs e)
        {
            doldurmüşteriler();
            doldurkargoad();
            personeldoldur();
            faturadoldur();
            

        }
        void silinensiparis()
        {
            baglanti.Open();
            NpgsqlCommand komut = new NpgsqlCommand("insert into silinensiparis(urunid,miktar) values (@p1,@p6)", baglanti);
            komut.Parameters.AddWithValue("@p1", textBox4.Text);
            komut.Parameters.AddWithValue("@p6", int.Parse(textBox6.Text));
            komut.ExecuteNonQuery();
            baglanti.Close();

        }
        private void button6_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlCommand komut = new NpgsqlCommand("insert into siparis (barkodno,musteriid,kargoid,personelid,faturaid,miktar,satisfiyat) values (@p1,@p2,@p3,@p4,@p5,@p6,@p7)", baglanti);
            komut.Parameters.AddWithValue("@p1", textBox4.Text);
   
            komut.Parameters.AddWithValue("@p2", comboBox1.SelectedValue.ToString());
            komut.Parameters.AddWithValue("@p3", int.Parse(comboBox2.SelectedValue.ToString()));
            komut.Parameters.AddWithValue("@p4", int.Parse(comboBox3.SelectedValue.ToString()));
            komut.Parameters.AddWithValue("@p5", int.Parse(comboBox4.SelectedValue.ToString()));
            komut.Parameters.AddWithValue("@p6", int.Parse(textBox6.Text));
            komut.Parameters.AddWithValue("@p7", int.Parse(textBox1.Text));
            komut.ExecuteNonQuery();
            baglanti.Close();
            MessageBox.Show("eklendi");
        }

        private void button11_Click(object sender, EventArgs e)
        {
            DialogResult dr = new DialogResult();
            dr = MessageBox.Show("Silmek istediğinize emin misiniz?", "", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            if (dr == DialogResult.Yes)
            {
                silinensiparis();
                baglanti.Open();
                NpgsqlCommand komut = new NpgsqlCommand("delete from siparis where barkodno=@p1", baglanti);
                komut.Parameters.AddWithValue("@p1", textBox4.Text);
                komut.ExecuteNonQuery();
                baglanti.Close();
                MessageBox.Show("silindi");
            }
        }

        private void textBox6_TextChanged(object sender, EventArgs e)
        {

        }

        private void dataGridView1_DoubleClick(object sender, EventArgs e)
        {
            int secilen = dataGridView1.SelectedCells[0].RowIndex;
            textBox4.Text = dataGridView1.Rows[secilen].Cells[0].Value.ToString();
            comboBox1.Text = dataGridView1.Rows[secilen].Cells[1].Value.ToString();
            textBox6.Text = dataGridView1.Rows[secilen].Cells[5].Value.ToString();
            
        }

        private void button8_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlCommand komut = new NpgsqlCommand("update siparis set musteriid=@p2,kargoid=@p3,personelid=@p4 ,faturaid=@p5,miktar=@p6  where barkodno=@p1", baglanti);
            komut.Parameters.AddWithValue("@p1", textBox4.Text);

            komut.Parameters.AddWithValue("@p2", comboBox1.SelectedValue.ToString());
            komut.Parameters.AddWithValue("@p3", int.Parse(comboBox2.SelectedValue.ToString()));
            komut.Parameters.AddWithValue("@p4", int.Parse(comboBox3.SelectedValue.ToString()));
            komut.Parameters.AddWithValue("@p5", int.Parse(comboBox4.SelectedValue.ToString()));
            komut.Parameters.AddWithValue("@p6", int.Parse(textBox6.Text));
            komut.ExecuteNonQuery();

            baglanti.Close();
            MessageBox.Show("güncellendi");
        }

        private void button10_Click(object sender, EventArgs e)
        {
            Form3 fr = new Form3();
            fr.Show();
        }
    }
}
