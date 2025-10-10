package app.business.nguoidung;

import javax.persistence.*;

@Entity
@Table(name = "BenhNhan")
@PrimaryKeyJoinColumn(name = "userId")
public class BenhNhan extends User {

    @Lob
    private String medicalHistory;

    public String getMedicalHistory() { return medicalHistory; }
    public void setMedicalHistory(String medicalHistory) { this.medicalHistory = medicalHistory; }
}
