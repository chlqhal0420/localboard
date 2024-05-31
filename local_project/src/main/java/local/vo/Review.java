package local.vo;

public class Review {
	private int reviewId; 		// 댓글ID
	private int lbId;// 게시글ID
	private int fileId;// 파일ID
	private int createdBy;		// 등록한회원ID
	private String createdIp;	// 등록한사람IP
	private String createdAt;	// 등록일시
	private String content;		// 내용
	private String nicknm;		// 닉네임
	private int memberId;
	private BoardFile boardFile;
	
	public int getReviewId() {
		return reviewId;
	}
	public void setReviewId(int reviewId) {
		this.reviewId = reviewId;
	}
	public int getLbId() {
		return lbId;
	}
	public void setLbId(int lbId) {
		this.lbId = lbId;
	}
	public int getFileId() {
		return fileId;
	}
	public void setFileId(int fileId) {
		this.fileId = fileId;
	}
	public int getCreatedBy() {
		return createdBy;
	}
	public void setCreatedBy(int createdBy) {
		this.createdBy = createdBy;
	}
	public String getCreatedIp() {
		return createdIp;
	}
	public void setCreatedIp(String createdIp) {
		this.createdIp = createdIp;
	}
	public String getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getNicknm() {
		return nicknm;
	}
	public void setNicknm(String nicknm) {
		this.nicknm = nicknm;
	}
	public int getMemberId() {
		return memberId;
	}
	public void setMemberId(int memberId) {
		this.memberId = memberId;
	} 
	
	
}
