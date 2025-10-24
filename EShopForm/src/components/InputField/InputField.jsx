import { useForm } from "react-hook-form"

const InputField = ({labelValue, inputType, register, value, placeholder, errorMessage}) => {
	return (
		<div>
		<label className="form-label">{labelValue}</label>
		<input
			className="form-input"
			type={inputType}
			placeholder={placeholder}
			{...register(value)}
		/>
		<p className="form-error">{errorMessage}</p>
		</div>
	)
}

export default InputField